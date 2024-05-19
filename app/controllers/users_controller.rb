class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :line_callback

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user), notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
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
          
          user = User.find_or_initialize_by(line_user_id: line_user_id)
          user.name = user_data['displayName']
          user.profile_image_url = user_data['pictureUrl']
          user.save!

          message = {
            type: 'text',
            text: "You have been successfully registered, #{user.name}!"
          }
          LINE_CLIENT.reply_message(event['replyToken'], message)
        end
      end
    end

    head :ok
  end

  def line_registration
    redirect_to new_user_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :line_user_id, :profile_image_url)
  end
end
