require 'jekyll/remote_csv/version'

require 'open-uri'
require 'csv'

require 'jekyll'

module Jekyll
  module RemoteCsv
    class Generator < ::Jekyll::Generator
      priority :low

      def generate(site)
        return unless site.config['remote_csv']
        site.config['remote_csv'].each do |source_name, conf|
          csv_string = open(conf['source']).read
          csv_data = CSV.parse(csv_string, headers: true).map(&:to_hash)
          site.collections[source_name] = make_collection(site, source_name, conf, csv_data)
          if conf['group_by']
            group_name = "#{source_name}_by_#{conf['group_by']}"
            site.collections[group_name] = make_group_collection(site, source_name, group_name, conf, site.collections[source_name].docs)
            site.collections[source_name].docs.each do |doc|
              doc.data[group_name] = site.collections[group_name].docs.find do |group|
                group['title'] == doc[conf['group_by']]
              end
            end
          end
          next unless conf['collections']
          conf['collections'].each do |collection_name, key|
            next unless site.collections.key?(collection_name)
            key ||= 'id'
            csv_id_field = conf.fetch('csv_id_field', 'id')
            site.collections[collection_name].docs.each do |doc|
              doc.data[source_name] = site.collections[source_name].docs.find_all do |item|
                item[csv_id_field] == doc[key]
              end
              doc.data[source_name].each do |source_doc|
                reverse_relation_name = conf.fetch('reverse_relation_name', collection_name)
                source_doc.data[reverse_relation_name] = doc
              end
            end
          end
        end
      end

      def make_collection(site, source_name, conf, csv_data)
        collection = Collection.new(site, source_name)
        csv_data.each do |item|
          item_id_field = conf.fetch('collection_slug_field', item.keys.first)
          path = File.join(site.source, "_#{source_name}", "#{Jekyll::Utils.slugify(item[item_id_field])}.md")
          doc = Document.new(path, collection: collection, site: site)
          doc.merge_data!(item)
          if site.layouts.key?(source_name)
            doc.merge_data!('layout' => source_name)
          end
          collection.docs << doc
        end
        collection
      end

      def make_group_collection(site, source_name, group_name, conf, data)
        collection = Collection.new(site, group_name)
        data.group_by { |d| d[conf['group_by']] }.each do |name, items|
          path = File.join(site.source, "_#{group_name}", "#{Jekyll::Utils.slugify(name)}.md")
          doc = Document.new(path, collection: collection, site: site)
          doc.merge_data!('title' => name, source_name => items)
          if site.layouts.key?(group_name)
            doc.merge_data!('layout' => group_name)
          elsif site.layouts.key?(source_name)
            doc.merge_data!('layout' => source_name)
          end
          collection.docs << doc
        end
        collection
      end
    end
  end
end
