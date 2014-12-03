# encoding: utf-8

require 'sprockets'

module Nanoc::Sprockets

  module Helper

    DEFAULT_ASSETS_DIRS = [
        'stylesheets', 'stylesheets/pages', 'stylesheets/vendor',
        'javascripts', 'javascripts/pages', 'javascripts/vendor',
        'fonts'
    ]

    DEFAULT_ASSETS_PATHS = [
        'content/assets/', 'vendor/assets/', 'static/assets/'
    ]

    class << self
      # Set the Sprockets environment to search for assets.
      # This defaults to the context's #environment method.
      def environment
        @environment ||= ::Sprockets::Environment.new(File.expand_path('.')) do |env|
          paths = DEFAULT_ASSETS_PATHS + DEFAULT_ASSETS_PATHS.map{|p| DEFAULT_ASSETS_DIRS.map{|f| "#{p}#{f}"}}.flatten
          paths.each{ |path| env.append_path path }
        end
      end
      attr_writer :environment

      # The base URL the Sprocket environment is mapped to.
      # This defaults to '/assets'.
      def prefix
        @prefix ||= '/assets'
      end
      attr_writer :prefix

    end

    # Convience method for configuring Nanoc::Sprockets::Helpers.
    def configure
      yield self
    end

    # Returns the path to an item or a filename either in the Sprockets environment.
    def asset_path(item_or_filename, options = {})
      if item_or_filename.is_a?(::Nanoc::Item)
        filename = item_or_filename[:filename]
      else
        filename = item_or_filename
      end
      filename = File.basename(filename).gsub(/^(\w+\.\w+).*/, '\1')

      if asset = Helper.environment[filename]
        File.join(Helper.prefix, asset.logical_path)
      else
        raise "error locating #{filename}."
      end
    end
  end

end