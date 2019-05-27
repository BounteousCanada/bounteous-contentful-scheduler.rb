require "thor"
require_relative 'scheduler'

module Bounteous
  module Contentful
    class CLI < Thor
      class_option :config, :aliases => "-c", :desc => "Configuration file location"
      class_option :access_token, :aliases => "-a", :desc => "Contentful Access Token"
      class_option :space_id, :aliases => "-s", :desc => "Contentful Space ID"
      class_option :environment_id, :aliases => "-e", :desc => "Contentful Environment ID (default: master)"


      desc "schedule", "Run the scheduler"
      method_option :default_locale, :aliases => "-l", :desc => "Contentful Default Locale (default: en-US)"
      method_option :quiet, :aliases => "-q", :type => :boolean, :desc => "Disable output printing"
      def schedule
        scheduler = Scheduler.new(options)
        scheduler.run
      end

      desc "install", "Install the scheduler against the provided Contentful Space"
      def install
        scheduler = Scheduler.new(options)
        scheduler.install
      end

      default_task :schedule
    end
  end
end