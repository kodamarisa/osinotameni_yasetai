class LineUsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :line_callback

  def new
    @line_user = LineUser.new
  end

  def create
    @line_user = LineUser.new(line_user_params)
    if @line_user.save
      if session[:current_calendar_id].present?
        calendar = Calendar.find(session[:current_calendar_id])
        calendar.users << @line_user unless calendar.users.include?(@line_user)
      end
      redirect_to line_user_path(@line_user), notice: 'Line User was successfully created.'
    else
      render :new
    end
  end

  def show
    @line_user = LineUser.find(params[:id])
  end

  def line_callback
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
          line_user_id = event['source']['userId']
          profile = LINE_CLIENT.get_profile(line_user_id)
          user_data = JSON.parse(profile.body)
  
          line_user = LineUser.find_or_initialize_by(line_user_id: line_user_id)
          line_user.name = user_data['displayName']
          line_user.profile_image_url = user_data['pictureUrl']
  
          if line_user.save!
            if session[:guest_user_id]
              guest_user = GuestUser.find(session[:guest_user_id])
  
              # ゲストユーザーからLineUserへのカレンダーの移行
              guest_calendars = Calendar.where(user_id: guest_user.id, user_type: 'GuestUser')
              guest_calendars.each do |calendar|
                calendar.update(user: line_user, user_type: 'LineUser')
              end
  
              # カレンダーのユーザー関連情報の更新
              CalendarUser.where(user_id: guest_user.id, user_type: 'GuestUser').update_all(user_id: line_user.id, user_type: 'LineUser')
  
              guest_user.destroy
              session.delete(:guest_user_id)
            end
  
            # オプション: line_userにカレンダーを関連付け
            if session[:current_calendar_id].present?
              calendar = Calendar.find(session[:current_calendar_id])
              calendar.users << line_user unless calendar.users.include?(line_user)
            end
  
            message = {
              type: 'text',
              text: "登録が完了しました、#{line_user.name}さん！"
            }
            LINE_CLIENT.reply_message(event['replyToken'], message)
          end
        end
      end
    end
  
    head :ok
  end  

  private

  def line_user_params
    params.require(:line_user).permit(:name, :line_user_id, :profile_image_url)
  end
end
