class MessagesController < ApiController
    before_action :authenticate_user!, only: [:create, :show]

    def show
        @group_id = params[:group_id]

        if !Group.exists?(id: @group_id)
            return render json: "{}", status: 404
        end

        if !current_user.groups.include? Group.find(@group_id)
            return render json: "{}", status: 403
        else
            @group = Group.find(@group_id)
            return render json: @group.messages, status: 200
        end
    end

    def create
        @message = Message.new(message_params)
        
        @group_id = params[:group_id]

        if !Group.exists?(id: @group_id)
            return render json: "{}", status: 404
        end

        if !current_user.groups.include? Group.find(@group_id)
            return render json: "{}", status: 403
        end

        @message.user_id = current_user.id
        @message.group_id = @group_id

        if @message.save
            return render json: @message, status: :created
        else
            return render json: @message.errors, status: 404
        end
    end

    private

    def message_params
        params.require(:message).permit(:content)
    end
end