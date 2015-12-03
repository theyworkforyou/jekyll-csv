require 'jekyll/everypolitician/education/version'

require 'open-uri'
require 'csv'

require 'jekyll'

module Jekyll
  module Everypolitician
    module Education
      class Generator < ::Jekyll::Generator
        def generate(site)
          csv_string = open(site.config['everypolitician']['education']).read
          site.data['education'] = CSV.parse(csv_string, headers: true).map(&:to_hash)
        end
      end
    end
  end
end
