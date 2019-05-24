# Bounteous::Contentful::Scheduler

Small Ruby application designed to schedule the publishing and unpublishing of entries and assets.

## Installation

    $ gem install bounteous-contentful-scheduler

## Usage
1. Start by running `bounteous-contentful-schedule install` with either command line options or by specifying a YAML file to use containing the required options.
This will create the "Scheduler - Publish" and "Scheduler - Unpublish" content types within the configured space.

    Command line options:       
    ```
    Options:
      -l, [--default-locale=DEFAULT_LOCALE]  # Contentful Default Locale (default: en-US)
      -q, [--quiet], [--no-quiet]            # Disable output printing
      -c, [--config=CONFIG]                  # Configuration file location
      -a, [--access-token=ACCESS_TOKEN]      # Contentful Access Token
      -s, [--space-id=SPACE_ID]              # Contentful Space ID
      -e, [--environment-id=ENVIRONMENT_ID]  # Contentful Environment ID (default: master)
    ```
    
    Example settings.yml:    
    ```
    #Contentful credentials
    access_token: DtY8jPFj2q130ejHQXVoAAPkmu4sOP3C6oO4VHvhbaB8fGTV0XuLodw8Z158
    space_id: 6SILbuIGe55h
    environment_id: master
    default_locale: en-CA
    ```
    
2. Next configure bounteous-contentful-scheduler to run via a cron

    Example cron configuration:
    ```
    # Edit this file to introduce tasks to be run by cron.
    # 
    # m h  dom mon dow   command
    PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    * * * * * /bin/bash -c 'bounteous-contentful-scheduler --config="/home/ubuntu/scheduler_settings.yml" >> /var/log/schdeuler-cron.log 2>&1'
    ```

3. Create new "Scheduler - Publish" and "Scheduler - Unpublish" entries within Contentful, setting the Date and Assets and Entries you wish to schedule publishing/unpublishing.

4. Profit!
     
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/BounteousCanada/bounteous-contentful-scheduler. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
