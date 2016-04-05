# Jekyll::RemoteCsv [![Build Status](https://travis-ci.org/everypolitician/jekyll-remote_csv.svg?branch=master)](https://travis-ci.org/everypolitician/jekyll-remote_csv)

This plugin takes a path or URL to a CSV file and uses the data to populate a [Jekyll Collection](https://jekyllrb.com/docs/collections/).

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
  <p>{{ item.name }}</p>
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
