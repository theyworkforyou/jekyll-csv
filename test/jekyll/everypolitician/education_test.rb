require 'test_helper'

class Jekyll::Everypolitician::EducationTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Jekyll::Everypolitician::Education::VERSION
  end

  def site
    @site ||= Jekyll::Site.new(Jekyll.configuration)
  end

  def setup
    site.config['remote_csv'] ||= {}
    site.config['remote_csv']['education'] = {
      'source' => 'test/fixtures/education.csv'
    }
  end

  def test_it_populates_site_data_with_education
    site.generate
    refute_nil site.data['education']
  end

  def test_the_correct_number_of_records_exist
    site.generate
    assert_equal 9, site.data['education'].size
  end

  def test_records_are_parse_correctly
    site.generate
    assert_equal 'Edward G. Cross', site.data['education'].first['name']
  end

  def test_adding_another_collection
    site.config['remote_csv']['foo_bar'] = site.config['remote_csv']['education']
    site.generate
    assert_equal 9, site.data['education'].size
    assert_equal 9, site.data['foo_bar'].size
  end

  def test_collections_are_populated
    site.config['everypolitician'] = {
      'sources' => ['test/fixtures/ep-popolo-v1.0.json']
    }
    site.config['remote_csv']['education']['collections'] = [
      'people'
    ]
    site.generate
    person = site.collections['people'].docs.first
    refute_nil person['education']
    assert_equal 'University of Zimbabwe', person['education'].first['organisation_name']
  end

  def test_overriding_csv_id_field
    site.config['everypolitician'] = {
      'sources' => ['test/fixtures/ep-popolo-v1.0.json']
    }
    site.config['remote_csv'] = {
      'education' => {
        'source' => 'test/fixtures/education_person_id.csv',
        'csv_id_field' => 'person_id',
        'collections' => ['people']
      }
    }
    site.generate
    person = site.collections['people'].docs.first
    refute_nil person['education']
    assert_equal 'University of Zimbabwe', person['education'].first['organisation_name']
  end

  def test_it_has_a_low_priority
    assert_equal :low, Jekyll::Everypolitician::Education::Generator.priority
  end
end
