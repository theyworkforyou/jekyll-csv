require 'jekyll/everypolitician/education/version'

require 'open-uri'
require 'csv'

require 'jekyll'
require 'jekyll/everypolitician'

module Jekyll
  module Everypolitician
    module Education
      class Generator < ::Jekyll::Generator
        def generate(site)
          csv_string = open(site.config['everypolitician']['education']).read
          site.data['education'] = CSV.parse(csv_string, headers: true).map(&:to_hash)
          site.collections['people'].docs.each do |person|
            kuvakazim_identifier = person.data['identifiers'].find { |id| id['scheme'] == 'kuvakazim' }
            next unless kuvakazim_identifier
            kuvakazim_id = kuvakazim_identifier['identifier']
            person.data['education_history'] = site.data['education'].find_all { |e| e['id'] == kuvakazim_id }
          end
        end
      end
    end
  end
end
