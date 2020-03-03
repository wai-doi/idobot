module Ruboty
  module Handlers
    class Collection < Base
      on(
        /まとめて\z/i,
        name: "collection",
        description: "今日の自分のメッセージをまとめてくれる！"
      )

      def collection(message)
        body = BodyGenerator.new(message.original.slice(:from_name, :room_id)).generate_body
        message.reply(body)
      end
    end
  end
end
