require_relative 'management'

module Bounteous
  module Contentful
    class Publisher < Management
      def publish
        puts DateTime.now.to_s + ' - Publisher Started' unless @config.quiet
        entries = @environment.entries.all(content_type: @config.publish_id, 'sys.publishedAt[exists]': "true", 'fields.processed[ne]': true)
        entries.each do |entry|
          next unless check_entry?(entry)

          puts DateTime.now.to_s + ' - Processing ' + entry.fields[:title] + ' (' + entry.id + ')' unless @config.quiet
          publish_entries(entry)
          publish_assets(entry)
          entry.fields[:processed] = true
          entry.fields[:title] = '(PROCESSED) ' + entry.fields[:title]
          entry.save.publish
        end
        puts DateTime.now.to_s + ' - Publisher Finished' unless @config.quiet
      end

      private

      def check_entry?(entry)
        entry.published? && check_date?(entry.fields[:date])
      end

      def check_date?(date)
        DateTime.parse(date).past?
      end

      def publish_entries(entry)
        entry.fields[:entries].each do |item|
          entry_to_publish = @environment.entries.find(item['sys']['id'])
          next if entry_to_publish.published?

          entry_to_publish.publish
          puts DateTime.now.to_s + ' - Published Entry ' + entry_to_publish.fields[:title] + ' (' + entry_to_publish.id + ')' unless @config.quiet
        end
      end

      def publish_assets(entry)
        entry.fields[:assets].each do |item|
          asset_to_publish = @environment.assets.find(item['sys']['id'])
          next if asset_to_publish.published?

          asset_to_publish.publish
          puts DateTime.now.to_s + ' - Published Asset ' + asset_to_publish.fields[:title] + ' (' + asset_to_publish.id + ')' unless @config.quiet
        end
      end
    end
  end
end