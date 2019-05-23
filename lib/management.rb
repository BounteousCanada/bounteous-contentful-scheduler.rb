require 'contentful/management'

module Bounteous
  module Contentful
    class Management
      attr_reader :config, :client, :environment

      def initialize(settings)
        @config = settings
        @client = ::Contentful::Management::Client.new(@config.access_token, default_locale: config.config['default_locale'] || 'en-US')
        @environment = @client.environments(@config.space_id).find(@config.environment_id)
      end
    end
  end
end
