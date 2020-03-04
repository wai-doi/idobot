module Ruboty
  module Handlers
    class Collection < Base
      class BodyGenerator
        API_URL = 'https://idobata.io/api/messages'
        CURL_LIMIT = 10

        def initialize(from_name:, room_id:, pretty: false)
          @from_name = from_name
          @room_id = room_id
          @pretty = pretty
        end

        def generate_body
          messages_from_api
            .select { |m| m.sent_by?(@from_name) && !m.mention_to_bot? && m.sent_on_today? }
            .map(&:body_plain)
            .join(join_string)
        end

        private

        def messages_from_api
          messages = []
          older_id = nil
          CURL_LIMIT.times do
            messages = JSON.parse(curl(older_id))['messages'].map { |m| Message.new(m) } + messages
            break unless messages.first&.sent_on_today?
            older_id = messages.first.id
            sleep 0.1
          end
          messages
        end

        def curl(older_id = nil)
          query = "?room_id=#{@room_id}"
          query += "&older_than=#{older_id}" if older_id

          `curl "#{API_URL}#{query}" -H "X-API-Token: #{ENV['IDOBATA_API_TOKEN']}"`
        end

        def join_string
          @pretty ? "\n\n---\n" : "\n"
        end
      end
    end
  end
end
