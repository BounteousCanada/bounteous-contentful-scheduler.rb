require "yaml"

module Bounteous
  module Contentful
    class Configuration
      attr_reader :config, :access_token, :space_id, :environment_id, :locale, :quiet, :publish_id, :unpublish_id

      def initialize(settings)
        @config = settings
        validate_required_parameters
        @access_token   = settings['access_token']
        @space_id       = settings['space_id']
        @environment_id = settings['environment_id'].present? ? settings['environment_id'] : 'master'
        @locale         = settings['default_locale'].present? ? settings['default_locale'] : 'en-US'
        @quiet          = settings['quiet'].present? ? settings['quiet'] : false
        @publish_id     = "bcs_publisher_scheduler"
        @unpublish_id   = "bcs_unpublisher_scheduler"
      end

      def validate_required_parameters
        fail ArgumentError, 'Missing space_id, must be supplied as argument or in configuration file. View README' if config['space_id'].nil?
        fail ArgumentError, 'Missing access_token, must be supplied as argument or in configuration file. View README' if config['access_token'].nil?
      end
    end
  end
end