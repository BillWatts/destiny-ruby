# Destiny
Is a work in progress gem that aims to put a easy to us wrapper around Bungie.net's largly undocumented Platfrom.  The will only focus on information related to Destiny, but will also provide access to other parts of the platform such as groups.

##Compatibility
This gem is a work in progress.  No testing as been done at this point.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'destiny-ruby'
```

And then execute:
```ruby    
    $ bundle
```
    
Or install it yourself as:
```ruby
    $ gem install destiny-ruby
```

## Usage
Currently only the Membership resource is available.  You can access it like so:

````ruby
  destiny_client = Destiny.new
  my_membership = destiny_client.memberships.get "mygamertag"
  my_membership.membership_id
  => "4611111111431694039"
````

If your Destiny character's are on Playstation you will need to specify the console:

````ruby
  destiny_client = Destiny.new({ console: :playstation })
````

Xbox will be default for this gem, so if you are an Xbox user you will not have to specify the console.

Please checkout the wiki for a full list of available resources and available attributes.

## Development.

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment. 

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/destiny_platform/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

##
