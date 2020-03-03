require 'date'

module Ruboty
  module Handlers
    class Collection < Base
      class Message
        attr_reader :id, :body_plain

        def initialize(args)
          @id = args['id']
          @sender_name = args['sender_name']
          @body_plain = args['body_plain']
          @created_on = Time.parse(args['created_at']).getlocal.to_date
        end

        def sent_on_today?
          @created_on == Date.today
        end

        def sent_by?(user_name)
          @sender_name == user_name
        end

        def mention_to_bot?
          @body_plain.match?(/@#{ENV['RUBOTY_NAME']}/)
        end
      end
    end
  end
end
