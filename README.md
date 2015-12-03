# Jekyll::RemoteCsv [![Build Status](https://travis-ci.org/everypolitician/jekyll-remote_csv.svg?branch=master)](https://travis-ci.org/everypolitician/jekyll-remote_csv)

This plugin allows you to specify remote CSVs to be turned into collections. It also provides a way for you to associate these collections with other collections.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jekyll-remote_csv'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jekyll-remote_csv

## Usage

In `_config.yml` add a section which points to a CSV of Education information:

```yaml
remote_csv:
  education:
    source: https://docs.google.com/spreadsheets/u/1/d/1rFnkM9rrhwmo5eTwhEPordgucf-iNACnzc6E78elkaM/export?format=csv
```

In this default configuration it will fetch the CSV at the url specified in the source attribute. It will the use the key as the name for the collection. In the example above `site.education` would be populated with the remote CSV:

```liquid
{% for item in site.education %}
  <p>{{ item.role }}</p>
{% endfor %}
```

### Associating with other collections

Sometimes you might want this collection to be associated with another collection, you can configure this in `_config.yml`:

```yaml
remote_csv:
  education:
    source: https://docs.google.com/spreadsheets/u/1/d/1rFnkM9rrhwmo5eTwhEPordgucf-iNACnzc6E78elkaM/export?format=csv
    collections:
      - assembly_people
      - senate_people
```

This will associate the collection in the source CSV with the `assembly_people` and `senate_people` collections. For this to work correctly each document in the collections will need to specify an `id` in its frontmatter which matches the `id` column in the CSV. If you need to override this then you can specify that:

```yaml
remote_csv:
  education:
    source: https://docs.google.com/spreadsheets/u/1/d/1rFnkM9rrhwmo5eTwhEPordgucf-iNACnzc6E78elkaM/export?format=csv
    csv_id_field: person_id
    collections:
      assembly_people: pombola_id
      senate_people: kuvakazim_id
```

This will use the `person_id` column in the CSV and match it to `assembly_people` using the `pombola_id` property in the frontmatter and the `senate_people` using the `kuvakazim_id` property. This means that each person in the collection will have an `education` property.

Assuming that the CSV file has `person_id`, `organization_name` and `qualification` columns you could then use this in a template listing people as follows:

```liquid
{% for person in site.assembly_people %}
  <h2>{{ person.name }} Education</h2>
  <ul>
  {% for education in person.education %}
    <li>Organisation: {{ education.organization_name }} | Qualification: {{ education.qualification }}</li>
  {% endfor %}
  </ul>
{% endfor %}
```

### Outputting a collection

If you want to output the collection then you will need to provide a key to use for the output item's slug.

```yaml
remote_csv:
  education:
    source: https://docs.google.com/spreadsheets/u/1/d/1rFnkM9rrhwmo5eTwhEPordgucf-iNACnzc6E78elkaM/export?format=csv
    collection_slug_field: organisation_name

collections:
  education:
    output: true
```

With the above configuration the education source CSV will be turned into a collection and then each item in the collection will be output at `/education/organisation-name-slugified`.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/everypolitician/jekyll-remote_csv.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
