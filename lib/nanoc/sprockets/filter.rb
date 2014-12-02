# encoding: utf-8

module Nanoc::Sprockets

  class Filter < Nanoc::Filter

    identifier :sprockets
    type :text

    def environment
      @environment ||= Nanoc::Sprockets::Helper.environment
    end

    def run(content, params = {})
      filename = File.basename(@item[:filename])

      environment.css_compressor = params[:css_compressor]
      environment.js_compressor  = params[:js_compressor]

      if asset = environment[filename]
        update_dependencies_for_current_item(asset.metadata[:dependency_paths])
        asset.to_s
      else
        raise "error locating #{filename} / #{@item[:filename]}"
      end
    end

    def update_dependencies_for_current_item(dependencies)
      dependencies.each do |dep|
        item = imported_filename_to_item(dep)
        depend_on([item]) unless item.nil? or item.identifier == @item.identifier
      end
    end

    def imported_filename_to_item(filename)
      @items.find do |i|
        i.raw_filename &&
            Pathname.new(i.raw_filename).realpath == Pathname.new(filename).realpath
      end
    end
  end
end