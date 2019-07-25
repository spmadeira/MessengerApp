class UsersController < ApplicationController
    def show_avatar
        @user = User.find(params[:user_id])
        return render json: @user.avatar, status: 200    
    end

    def create_avatar
        encoded_image = avatar_params.split(",")[1]
        @user = User.find(params[:user_id])
        StringIO.open(Base64.decode64(encoded_image)) do |data|
            data.class.class_eval { attr_accessor :original_filename, :content_type }
            data.original_filename = "avatar.png"
            data.content_type = "image/png"
            @user.avatar = data
        end

        @user.save

        return render json: { user_id: @user.id, avatar_url: @user.avatar}, status: 200
    end

    def avatar_params
        params[:avatar]
    end
end