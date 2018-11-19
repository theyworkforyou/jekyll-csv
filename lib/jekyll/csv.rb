require 'jekyll/csv/version'

require 'open-uri'
require 'csv'

require 'jekyll'

module Jekyll
  module Csv
    class CollectionPopulator
      attr_reader :conf

      def initialize(conf)
        @conf = conf
      end

      def populate(site)
        collection = Collection.new(site, collection_name)
        csv_data.each do |item|
          path = File.join(site.source, "_#{collection_name}", "#{Jekyll::Utils.slugify(item[slug_field])}.md")
          doc = Document.new(path, collection: collection, site: site)
          doc.merge_data!(item)
          if site.layouts.key?(collection_name)
            doc.merge_data!('layout' => collection_name)
          end
          collection.docs << doc
        end
        site.collections[collection_name] = collection
      end

      def collection_name
        @collection_name ||= conf['collection_name']
      end

      def csv_data
        data = CSV.parse(csv_string, headers: true).map(&:to_hash)
        data.delete_if do |item|
          reject = false
          conf['mandatory'].each do |field|
            if item[field].nil? || item[field].empty?
              reject = true
              break
            end
          end
          reject
        end
        data.map do |item|
          conf['convert_to_int'].each do |field|
            unless item[field].nil?
              item.merge!(field + '_int' => item[field].gsub(/\s+/, '').to_i)
            end
          end
        end
        @csv_data ||= data
      end

      def csv_string
        @csv_string ||= open(conf['source']).read
      end

      def slug_field
        @slug_field ||= conf.fetch('slug', csv_data.first.keys.first)
      end
    end

    class Generator < ::Jekyll::Generator
      priority :low

      def generate(site)
        return unless site.config['csv']
        site.config['csv'].each do |collection_name, conf|
          conf['collection_name'] = collection_name
          CollectionPopulator.new(conf).populate(site)
        end
      end
    end
  end
end
