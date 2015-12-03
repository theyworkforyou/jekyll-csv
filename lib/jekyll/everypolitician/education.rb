require 'jekyll/everypolitician/education/version'

require 'open-uri'
require 'csv'

require 'jekyll'
require 'jekyll/everypolitician'

module Jekyll
  module Everypolitician
    module Education
      class Generator < ::Jekyll::Generator
        priority :low

        def generate(site)
          return unless site.config['remote_csv']
          site.config['remote_csv'].each do |source_name, conf|
            csv_string = open(conf['source']).read
            site.data[source_name] = CSV.parse(csv_string, headers: true).map(&:to_hash)
            next unless conf['collections']
            conf['collections'].each do |collection, key|
              next unless site.collections.key?(collection)
              key ||= 'id'
              csv_id_field = conf.fetch('csv_id_field', 'id')
              site.collections[collection].docs.each do |person|
                person.data[source_name] = site.data[source_name].find_all do |item|
                  item[csv_id_field] == person[key]
                end
              end
            end
          end
        end
      end
    end
  end
end
