module Ruboty
  module Handlers
    class Collection < Base
      on(
        /まとめて\z/,
        name: "collection",
        description: "今日の自分のメッセージをまとめてくれる！"
      )

      on(
        /きれいにまとめて\z/,
        name: "pretty_collection",
        description: "今日の自分のメッセージをきれいにまとめてくれる！",
      )

      def collection(message)
        attributes = message.original.slice(:from_name, :room_id)
        message.reply(body(attributes))
      end

      def pretty_collection(message)
        attributes = message.original.slice(:from_name, :room_id).merge(pretty: true)
        message.reply(body(attributes))
      end

      private

      def body(attributes)
        BodyGenerator.new(attributes).generate_body
      end
    end
  end
end
