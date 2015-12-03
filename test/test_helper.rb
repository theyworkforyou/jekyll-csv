$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'jekyll/remote_csv'

Jekyll.logger.log_level = :error

require 'minitest/autorun'
