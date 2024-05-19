class LineBotController < ApplicationController
  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']

    unless LINE_CLIENT.validate_signature(body, signature)
      head :bad_request
      return
    end

    events = LINE_CLIENT.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: event.message['text']
          }
          LINE_CLIENT.reply_message(event['replyToken'], message)
        end
      end
    end

    head :ok
  end
end
