require 'test_helper'

class Jekyll::Everypolitician::EducationTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Jekyll::Everypolitician::Education::VERSION
  end

  def site
    @site ||= Jekyll::Site.new(Jekyll.configuration).tap do |s|
      s.config['everypolitician'] ||= {}
      s.config['everypolitician']['sources'] = ['test/fixtures/ep-popolo-v1.0.json']
      s.config['everypolitician']['education'] = 'test/fixtures/education.csv'
    end
  end

  def setup
    site.generate
  end

  def test_it_populates_site_data_with_education
    refute_nil site.data['education']
  end

  def test_the_correct_number_of_records_exist
    assert_equal 9, site.data['education'].size
  end

  def test_records_are_parse_correctly
    assert_equal 'Edward G. Cross', site.data['education'].first['name']
  end
end
