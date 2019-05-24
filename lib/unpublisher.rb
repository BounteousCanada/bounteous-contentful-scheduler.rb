require_relative 'management'

module Bounteous
  module Contentful
    class Unpublisher < Management
      def unpublish
        puts DateTime.now.to_s + ' - Unpublisher Started' unless @config.quiet
        entries = @environment.entries.all(content_type: @config.unpublish_id, 'sys.publishedAt[exists]': "true", 'fields.processed[ne]': true)
        entries.each do |entry|
          next unless check_entry?(entry)

          puts DateTime.now.to_s + ' - Processing ' + entry.fields[:title] + ' (' + entry.id + ')' unless @config.quiet
          unpublish_entries(entry)
          unpublish_assets(entry)
          entry.fields[:processed] = true
          entry.fields[:title] = '(PROCESSED) ' + entry.fields[:title]
          entry.save.publish
        end
        puts DateTime.now.to_s + ' - Unpublisher Finished' unless @config.quiet
      end

      private

      def check_entry?(entry)
        entry.published? && check_date?(entry.fields[:date])
      end

      def check_date?(date)
        DateTime.parse(date).past?
      end

      def unpublish_entries(entry)
        entry.fields[:entries].each do |item|
          entry_to_unpublish = @environment.entries.find(item['sys']['id'])
          next unless entry_to_unpublish.published?

          entry_to_unpublish.unpublish
          puts DateTime.now.to_s + ' - Unpublished Entry ' + entry_to_unpublish.fields[:title] + ' (' + entry_to_unpublish.id + ')' unless @config.quiet
        end
      end

      def unpublish_assets(entry)
        entry.fields[:assets].each do |item|
          asset_to_unpublish = @environment.assets.find(item['sys']['id'])
          next unless asset_to_unpublish.published?

          asset_to_unpublish.unpublish
          puts DateTime.now.to_s + ' - Unpublished Asset ' + asset_to_unpublish.fields[:title] + ' (' + asset_to_unpublish.id + ')' unless @config.quiet
        end
      end
    end
  end
end