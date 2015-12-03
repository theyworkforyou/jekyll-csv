# Jekyll::Everypolitician::Education [![Build Status](https://travis-ci.org/everypolitician/jekyll-everypolitician-education.svg?branch=master)](https://travis-ci.org/everypolitician/jekyll-everypolitician-education)

Designed to be be used in conjunction with [jekyll-everypolitician](https://github.com/everypolitician/jekyll-everypolitician). This allows you to add a CSV of Education history to display for a person.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jekyll-everypolitician-education'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jekyll-everypolitician-education

## Usage

In `_config.yml` add a section which points to a CSV of Education information:

```yaml
everypolitician:
  education: https://docs.google.com/spreadsheets/u/1/d/1rFnkM9rrhwmo5eTwhEPordgucf-iNACnzc6E78elkaM/export?format=csv&id=1rFnkM9rrhwmo5eTwhEPordgucf-iNACnzc6E78elkaM&gid=0
  sources: ...
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/everypolitician/jekyll-everypolitician-education.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
