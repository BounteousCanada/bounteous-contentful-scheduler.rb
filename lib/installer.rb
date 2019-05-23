require_relative 'management'

module Bounteous
  module Contentful
    class Installer < Management
      def install
        puts 'Setting up Scheduler Content Types...'
        publish_content_type = @environment.content_types.find(@config.publish_id)
        create_publish_scheduler unless publish_content_type.instance_of?(::Contentful::Management::ContentType)
        puts 'Scheduler Publish already exists.' if publish_content_type.instance_of?(::Contentful::Management::ContentType)
        unpublish_content_type = @environment.content_types.find(@config.unpublish_id)
        create_unpublish_scheduler unless unpublish_content_type.instance_of?(::Contentful::Management::ContentType)
        puts 'Scheduler Unpublish already exists.' if unpublish_content_type.instance_of?(::Contentful::Management::ContentType)
        puts 'Complete.'
      end

      def create_publish_scheduler
        puts 'Creating Scheduler Publish'

        title_field      = ::Contentful::Management::Field.new
        title_field.id   = 'title'
        title_field.name = 'Title'
        title_field.type = 'Symbol'

        link_field           = ::Contentful::Management::Field.new
        link_field.type      = 'Link'
        link_field.link_type = 'Entry'

        multi_link_field       = ::Contentful::Management::Field.new
        multi_link_field.id    = 'items'
        multi_link_field.name  = 'Items'
        multi_link_field.type  = 'Array'
        multi_link_field.items = link_field

        date_field      = ::Contentful::Management::Field.new
        date_field.id   = 'date'
        date_field.name = 'Publish Date'
        date_field.type = 'Date'

        processed_field          = ::Contentful::Management::Field.new
        processed_field.id       = 'processed'
        processed_field.name     = 'Processed'
        processed_field.type     = 'Boolean'
        processed_field.disabled = true

        content_type                           = @environment.content_types.new
        content_type.name                      = 'Scheduler - Publish'
        content_type.id                        = @config.publish_id
        content_type.properties[:displayField] = 'title'
        content_type.fields                    = [title_field, date_field, multi_link_field, processed_field]
        content_type.save
        content_type.activate

        puts 'Scheduler Publish Created and Activated!'
      end

      def create_unpublish_scheduler
        puts 'Creating Scheduler Unpublish'

        title_field      = ::Contentful::Management::Field.new
        title_field.id   = 'title'
        title_field.name = 'Title'
        title_field.type = 'Symbol'

        link_field           = ::Contentful::Management::Field.new
        link_field.type      = 'Link'
        link_field.link_type = 'Entry'

        multi_link_field       = ::Contentful::Management::Field.new
        multi_link_field.id    = 'items'
        multi_link_field.name  = 'Items'
        multi_link_field.type  = 'Array'
        multi_link_field.items = link_field

        date_field      = ::Contentful::Management::Field.new
        date_field.id   = 'date'
        date_field.name = 'Unpublish Date'
        date_field.type = 'Date'

        processed_field          = ::Contentful::Management::Field.new
        processed_field.id       = 'processed'
        processed_field.name     = 'Processed'
        processed_field.type     = 'Boolean'
        processed_field.disabled = true

        content_type                           = @environment.content_types.new
        content_type.name                      = 'Scheduler - Unpublish'
        content_type.id                        = @config.unpublish_id
        content_type.properties[:displayField] = 'title'
        content_type.fields                    = [title_field, date_field, multi_link_field, processed_field]
        content_type.save
        content_type.activate

        puts 'Scheduler Unpublish Created and Activated!'
      end
    end
  end
end
