class ViewsController < ApplicationController
    before_action :authenticate_user!, only: [:main, :get_group, :create_group, :send_message, :destroy_group, :user_profile, :add_photo]

    def main
        @user = current_user
        @groups = current_user.groups
    end

    def user_profile
        
    end

    def add_photo
        encoded_image = params[:avatar].split(",")[1]
        StringIO.open(Base64.decode64(encoded_image)) do |data|
            data.class.class_eval { attr_accessor :original_filename, :content_type }
            data.original_filename = "avatar.png"
            data.content_type = "image/png"
            current_user.avatar = data
        end

        current_user.save
        redirect_to "/web/users/#{current_user.id}"
    end

    def create_group
        @group = Group.new
    end

    def get_group
        @group = Group.find(params[:group_id])
        @message = Message.new
    end

    def send_message
        @message = Message.new(message_params)
        @message.group_id = params[:group_id]
        @message.user_id = current_user.id

        #Caso o usuario não esteja no grupo escolhido
        if !Group.exists?(id: @message.group_id)
            return render json: "{}", status: 404
        end

        @group = Group.find(@message.group_id)

        if !current_user.groups.include? @group
            return render json: "{}", status: 403
        end

        respond_to do |format|
            if @message.save
                format.html{ redirect_to "/web/groups/#{@group.id}"}
                format.json{render :show, status: :created, location: @message }
            else
                @message = Message.new
                format.html { render :new }
                format.json { render json: @message.errors, status: :unprocessable_entity }
            end
        end

    end

    def destroy_group
        @group_id = params[:group_id]
        if !Group.exists?(id: @group_id)
            return render json: "{}", status: 404
        end

        @group = Group.find(@group_id)

        if @group.owner_id != current_user.id
            return render json: "{}", status: 403
        end

        @group.user_groups.destroy
        @group.destroy

        respond_to do |format|
            format.html {redirect_to "/main"}
        end

    end

    def create
        @group = Group.new(group_params)
        @group.owner_id = current_user.id

        respond_to do |format|
            if @group.save
                @ug = UserGroup.create(user_id: current_user.id, group_id: @group.id)

                # current_user.user_groups.orderdesc.push(@ug)
                # @group.usergroups.orderdesc.push(@ug)

                format.html { redirect_to '/main', notice: 'Grupo Criado' }
                format.json { render :show, status: :created, location: @group }
            else
                @group = Group.new
                format.html { render :new }
                format.json { render json: @group.errors, status: :unprocessable_entity }
            end
          end
    end

    private

    def group_params
        params.require(:group).permit(:name,:category)
    end

    def message_params
        params.require(:message).permit(:content)
    end
end