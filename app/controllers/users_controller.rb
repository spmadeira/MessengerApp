class UsersController < ApiController
    before_action :authenticate_user!, only: [:get_user, :show, :show_avatar, :create_avatar, :leave]

    def show
        @user_id = params[:user_id]

        if !User.exists?(id: @user_id)
            return render json: "{}", status: 404
        end

        @user = User.find(@user_id)

        return render json: @user, status: 200
    end

    def get_user
        return render json: current_user.user_data, status:200
    end

    def group_join
        @user_id = params[:user_id]
        if !User.exists?(id: @user_id)
            return render json: "{}", status: 404
        end

        @user = User.find(@user_id)

        @group_id = params[:group_id]

        if !Group.exists?(id: @group_id)
            return render json: "{}", status: 404
        end

        @group = Group.find(@user_id)

        if @user.groups.include? Group.find(@group_id)
            return render json: UserGroup.all.where(user_id: @user.id, group_id: @group.id), status: 200
        end

        @usergroup = UserGroup.create(user_id: @user.id, group_id: @group.id)

        return render json: @usergroup, status: 200
    end

    def group_leave
        @user_id = params[:user_id]
        if !User.exists?(id: @user_id)
            return render json: "{}", status: 404
        end
        @user = User.find(@user_id)

        @group_id = params[:group_id]

        if !Group.exists?(id: @group_id)
            return render json: "{}", status: 404
        end

        if !@user.groups.include? Group.find(@group_id)
            return render json: "{}", status: 403
        end

        @group = Group.find(@user_id)
        @usergroup = @group.user_groups.where(user_id: @user.id).first

        @usergroup.destroy

        return render json: UserGroup.with_deleted.where(user_id: @user.id, group_id: @group.id), status: 200
    end

    def show_avatar
        @user = User.find(params[:user_id])
        return render json: @user.avatar, status: 200    
    end

    def create_avatar
        encoded_image = avatar_params.split(",")[1]
        @user = current_user
        StringIO.open(Base64.decode64(encoded_image)) do |data|
            data.class.class_eval { attr_accessor :original_filename, :content_type }
            data.original_filename = "avatar.png"
            data.content_type = "image/png"
            @user.avatar = data
        end

        @user.save

        return render json: { user_id: @user.id, avatar_url: @user.avatar}, status: 200
    end

    private

    def avatar_params
        params[:avatar]
    end
end