# FlowdockNotify

This is used by the build agent to notify the person who (most likely)
started the build that their build is complete, whether or not it failed
or passed.

The teamcity api is used to fetch information about the build because we
cannot find it out in the environment.

## Installation

Add this line to your application's Gemfile:

    gem 'flowdock-build-notifier'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flowdock_notify

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( http://github.com/<my-github-username>/flowdock_notify/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
