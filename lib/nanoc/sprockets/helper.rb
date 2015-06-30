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

    # Define default paths loaded in default Sprockets environments
    DEFAULT_PATHS = DEFAULT_ASSETS_PATHS + DEFAULT_ASSETS_PATHS.map{|p| DEFAULT_ASSETS_DIRS.map{|f| "#{p}#{f}"}}.flatten

    class << self
      # Set the Sprockets environment to search for assets.
      # This defaults to the context's #environment method.
      def environment
        @environment ||= ::Sprockets::Environment.new(File.expand_path('.')) do |env|
          # Append predefined paths
          DEFAULT_PATHS.each{ |path| env.append_path path }
          # Provide fallback implementation for asset_path in case no handler is found
          env.context_class.class_eval do
            def asset_path(path, options = {})
              if Helper.debug
                warn "Using fallback implementation of asset_path with #{path}"
              end
              File.join(Helper.prefix, path)
            end
          end
        end
      end
      attr_writer :environment

      # The base URL the Sprocket environment is mapped to.
      # This defaults to '/assets'.
      def prefix
        @prefix ||= '/assets'
      end
      attr_writer :prefix

      # When true, activate debug mode
      attr_accessor :debug
      attr_writer :debug

      # When true, the asset paths will return digest paths
      attr_accessor :digest
    end

    # Convience method for configuring Nanoc::Sprockets::Helpers.
    def configure
      yield self
    end

    # Returns the path to an item or a filename in the Sprockets environment.
    def asset_path(item_or_filename, options = {})
      if item_or_filename.is_a? String
        filename = item_or_filename
      else
        filename = item_or_filename[:filename]
      end
      filename = File.basename(filename).gsub(/^(\w+\.\w+).*/, '\1')

      if asset = Helper.environment.find_asset(filename)
        if Helper.digest
          File.join(Helper.prefix, asset.digest_path)
        else
          File.join(Helper.prefix, asset.logical_path)
        end
      else
        raise "Something is wrong: unable to locate #{filename}."
      end
    rescue TypeError => error
      raise "Unable to process `#{item_or_filename}` ensure that you provided a valid Nanoc::Item or a filename: #{error}"
    end
  end

end
