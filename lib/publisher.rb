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
          entry.fields[:items].each do |item|
            entry_to_publish = @environment.entries.find(item['sys']['id'])
            next if entry_to_publish.published?

            entry_to_publish.publish
            puts DateTime.now.to_s + ' - Published ' + entry_to_publish.fields[:title] + ' (' + entry_to_publish.id + ')' unless @config.quiet
          end
          entry.fields[:processed] = true
          entry.fields[:title] = '(PROCESSED) ' + entry.fields[:title]
          entry.save
        end
        puts DateTime.now.to_s + ' - Publisher Finished' unless @config.quiet
      end

      def check_entry?(entry)
        entry.published? && check_date?(entry.fields[:date])
      end

      def check_date?(date)
        DateTime.parse(date).past?
      end
    end
  end
end