require "yaml"
require 'active_support/core_ext/hash'
require_relative 'version'

module Bounteous
  module Contentful
    class Scheduler
      require_relative 'configuration'
      require_relative 'publisher'
      require_relative 'unpublisher'
      require_relative 'installer'

      attr_reader :settings, :config

      def initialize(options)
        abort(DateTime.now.to_s + ' - Unable to obtain lock. Aborting.') unless cron_lock

        @settings = {}
        allowed_override = %w[space_id access_token environment_id default_locale quiet]

        settings_file = options[:config]
        @settings.merge!(YAML.load_file(settings_file) || {}) if settings_file

        # CLI options can override settings of the same name
        options.each_key do |key|
          @settings[key] = options[key] if allowed_override.include?(key)
        end

        @settings = @settings.with_indifferent_access
      end

      def run
        @config = Configuration.new(@settings)
        publisher = Publisher.new(@config)
        publisher.publish
        unpublisher = Unpublisher.new(@config)
        unpublisher.unpublish
      end

      def install
        @config = Configuration.new(@settings)
        installer = Installer.new(@config)
        installer.install
      end

      private

      def cron_lock
        file = File.new('/tmp/bounteous-contentful-scheduler.lock', 'w')
        file.flock(File::LOCK_EX | File::LOCK_NB)
      end
    end
  end
end
