class MessagesController < ApplicationController
    before_action :authenticate_user!, only: [:create]

    def create
        @message = Message.new(message_params)
        
        @group_id = params[:group_id]

        if !Group.exists?(id: @group_id)
            render json: "{}", status: 404
        end

        if !current_user.groups.include? Group.find(@group_id)
            render json: "{}", status: 403
        end

        @message.user_id = current_user.id
        @message.group_id = @group_id

        if @message.save
            render json: @message, status: :created
        else
            render json: @message.errors, status: 404
        end
    end

    private

    def message_params
        params.require(:message).permit(:content)
    end
end