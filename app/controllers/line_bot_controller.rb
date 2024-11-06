class LineBotController < ApplicationController
  def line_callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']

    unless LINE_CLIENT.validate_signature(body, signature)
      logger.error 'Invalid LINE signature'
      head :bad_request
      return
    end

    events = LINE_CLIENT.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          line_user_id = event['source']['userId']

          # エラーハンドリング：プロファイル取得失敗
          profile_response = LINE_CLIENT.get_profile(line_user_id)
          if profile_response.code != 200
            logger.error "Failed to get LINE profile for user ID: #{line_user_id}"
            head :internal_server_error
            return
          end

          user_data = JSON.parse(profile_response.body)

          # LineUserの作成または取得
          line_user = LineUser.find_or_initialize_by(line_user_id: line_user_id)
          line_user.name = user_data['displayName']
          line_user.profile_image_url = user_data['pictureUrl']
  
          if line_user.save
            # ゲストユーザーからのカレンダー移行処理（既存のまま）
            if session[:guest_user_id]
              # 以下、既存コード
            end

            # カレンダーの紐付けと登録メッセージ送信（既存コード）
          else
            logger.error "Failed to save LINE user: #{line_user.errors.full_messages}"
            head :unprocessable_entity
            return
          end
        end
      end
    end

    head :ok
  end
end
