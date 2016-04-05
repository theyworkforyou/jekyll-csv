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
    end
  end
end
