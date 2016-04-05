require 'test_helper'

class Jekyll::RemoteCsvTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Jekyll::RemoteCsv::VERSION
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

  def add_people_collection_to_site
    people = Jekyll::Collection.new(site, 'people')
    path = File.join(site.source, "_people", "test.md")
    person = Jekyll::Document.new(path, collection: people, site: site)
    person.data['id'] = '22'
    people.docs << person
    site.collections['people'] = people
  end

  def test_it_populates_site_data_with_education
    site.generate
    refute_nil site.collections['education']
  end

  def test_turning_csv_into_collection
    site.generate
    refute_nil site.collections['education']
    assert_equal 9, site.collections['education'].docs.size
  end

  def test_records_are_parsed_correctly
    site.generate
    assert_equal 'Edward G. Cross', site.collections['education'].docs.first.data['name']
  end

  def test_adding_another_collection
    site.config['remote_csv']['foo_bar'] = site.config['remote_csv']['education']
    site.generate
    assert_equal 9, site.collections['education'].docs.size
    assert_equal 9, site.collections['foo_bar'].docs.size
  end

  def test_it_has_a_low_priority
    assert_equal :low, Jekyll::RemoteCsv::Generator.priority
  end

  def test_collection_slug_field
    site.config['remote_csv']['education']['collection_slug_field'] = 'organisation_name'
    site.generate
    doc = site.collections['education'].docs.first
    assert_equal 'gwebi-agricultural-college', doc.basename_without_ext
  end
end
