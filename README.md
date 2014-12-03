# Nanoc::Sprockets3

A nanoc extension to use [Sprockets 3.x][sprockets], a Ruby library for compiling and serving web assets.

You are using [nanoc-sprockets-filter][nanoc-sprockets-filter] or [nanoc-sprockets-datasource][nanoc-sprockets] and
you would like to use Sprockets 3.x to take advantages of the news features then [nanoc-sprockets3] is
what you are looking for !

**Note:** *Unlike [nanoc-sprockets-filter] or [nanoc-sprockets] that lack a support
for dependency tracking, which is annoying when working with partials and/or livereload, [nanoc-sprockets3] is built
on top of [Sprockets 3.x][sprockets] and integrates seamlessly with Nanoc3/nanoc4 and livereload.
With [nanoc-sprockets3] no need to clear the cache or purge the output to regenerate your assets whenever partials
or dependencies change !*

## Installation

Add this line to your application's Gemfile:

    gem 'nanoc-sprockets3'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nanoc-sprockets3

## Configuration

[nanoc-sprockets3][nanoc-sprockets3] does not require any mandatory configuration, however you may want to configure it
for your needs.

Currently you can configure [nanoc-sprockets3][nanoc-sprockets3] with the following parameters:
 - **prefix** *[default: '/asset']* which is the prefix to give to all assets
 - **digest** *[default: false]* which when true will return digest paths instead of logical path
 - **environment** which is the Sprockets environment to use

The default environment is configured with the following paths
- content/assets/
- vendor/assets/
- static/assets/

concatenated with the following sub-paths
- stylesheets
- stylesheets/pages
- stylesheets/vendor
- javascripts
- javascripts/pages
- javascripts/vendor
- fonts

To load the default  [nanoc-sprockets] configuration do as follow:

```ruby
include Nanoc::Sprockets::Helper

```

To fully customize the [nanoc-sprockets] configuration do as follow:

```ruby
include Nanoc::Sprockets::Helper

Nanoc::Sprockets::Helper.configure do |config|
  config.environment = ::Sprockets::Environment.new(File.expand_path('.')) do |env|
    env.append_path 'app/assets/javascripts'
    env.append_path 'lib/assets/javascripts'
    env.append_path 'vendor/assets/jquery'
  end
  config.prefix      = '/assets'
  config.digest      = true
end
```

**Note:** you can find more advanced configuration on the [sprockets website][sprockets].

## Usage

We recommend the use of [uglifier][uglifier] gem to minify javascripts.
You may use any other compressor supported by Sprockets.

Add compile rule for stylesheets and javascripts, `css_compressor`and `js_compressor` is optional
and value can be replaced by any compressor supported by Sprockets.
Add route rule for all assets and use `Nanoc::Sprockets::Helper.asset_path(item)` to generate file path.

```ruby
compile %r{/assets/(stylesheets|javascripts)/.+/} do
  filter :sprockets, {
    :css_compressor => :scss,
    :js_compressor  => :uglifier
  }
end

route '/assets/*/' do
  Nanoc::Sprockets::Helper.asset_path(item)
end
```

You can use [nanoc-gzip-filter][nanoc-gzip-filter] to create a
gzipped version of stylesheets and javascripts files.

```ruby
compile %r{/assets/(stylesheets|javascripts)/.+/} do
  filter :sprockets, {
    :css_compressor => :scss,
    :js_compressor  => :uglifier
  }
  snapshot :text
  filter :gzip
end

route '/assets/*/', :snapshot => :text do
  Nanoc::Sprockets::Helper.asset_path(item)
end

route '/assets/*/' do
  Nanoc::Sprockets::Helper.asset_path(item) + '.gz'
end
```

**Note:** Don't forget to require 'nanoc-sprockets' (e.g in `lib/default.rb`)


## Contributing

1. Fork it ( http://github.com/<my-github-username>/nanoc-sprockets/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Acknowledgement

I wrote this plugin to bring the support of Sprockets 3.x to nanoc and take benefit of the dependencies tracking system
introduced in Sprockets 3.x.

This plugin is inspired by [nanoc-sprockets-filter][nanoc-sprockets-filter] which support Sprockets 2.x but lacks a support
for dependency tracking which makes it annoying to use with livereload and partials.

[nanoc-sprockets3]: https://github.com/barraq/nanoc-sprockets "Sprockets 3.x support for nanoc"
[sprockets]: https://github.com/sstephenson/sprockets "Rack-based asset packaging"
[nanoc-sprockets-filter]: https://github.com/yannlugrin/nanoc-sprockets-filter "A nanoc filter to use Sprocket 2.x"
[nanoc-sprockets]: https://github.com/stormz/nanoc-sprockets "Use sprockets 2.x as a datasource for nanoc"
[nanoc-gzip-filter]: https://github.com/yannlugrin/nanoc-gzip-filter "A Nanoc filter to gzip content"
[uglifier]: https://github.com/lautis/uglifier "Ruby wrapper for UglifyJS JavaScript compressor"