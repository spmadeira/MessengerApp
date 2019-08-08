class GroupsController < ApiController
    before_action :authenticate_user!, only: [:delete_group, :remove_user, :change_group_privacy, :get_group, :create, :show, :delete, :get_groups, :other_groups, :send_invite]

    def other_groups
        @groups = Group.all.where(private: false) - (current_user.groups + current_user.invite_groups)

        @json = [""];

        @groups.each do |group|
            @json.push(group.external_info);
        end

        @json.shift();

        return render json: @json, status: 200
    end

    def change_group_privacy
        @group_id = params[:group_id]

        if !Group.exists?(id: @group_id)
            return render json: "{}", status: 404
        end

        @group = Group.find(@group_id)

        if @group.owner_id != current_user.id
            return render json: "{}", status: 403
        end

        @group.private = !@group.private
        @group.save

        return render json: "{}", status: 200
    end

    def remove_user
        @group_id = params[:group_id]

        if !Group.exists?(id: @group_id)
            return render json: "{}", status: 404
        end

        @group = Group.find(@group_id)

        if @group.owner_id != current_user.id
            return render json: "{}", status: 403
        end

        @user_id = params[:user_id]

        if @user.id == @group.owner_id
            return delete_group
        end

        @usergroup = @group.user_groups.where(user_id: @user.id).first

        @usergroup.destroy

        return render json: "{}", status: 200
    end

    def delete_group
        @group_id = params[:group_id]

        if !Group.exists?(id: @group_id)
            return render json: "{}", status: 404
        end

        @group = Group.find(@group_id)

        if @group.owner_id != current_user.id
            return render json: "{}", status: 403
        end

        @usergroups = @group.user_groups

        @gid = @group.id

        @group.destroy
        @usergroups.destroy

        render json: {group: Group.with_deleted.find(@gid)}, status: 200
    end

    def get_group
        @group_id = params[:group_id]

        if !Group.exists?(id: @group_id)
            return render json: "{}", status: 404
        end

        @group = Group.find(@group_id)

        if !current_user.groups.include? @group
            return render json: "{}", status: 403
        end

        @json = {
            id: @group.id,
            privacy: @group.privacy,
            users: @group.users - [current_user],
            messages: @group.messages,
            invites: current_user.id == @group.owner_id ? @group.invites : null,
            is_owner: current_user.id == @group.owner_id,
        }

        return render json: @json, status: 200
    end

    def send_invite
        @group_id = params[:group_id]

        if !Group.exists?(id: @group_id)
            return render json: "{}", status: 404
        end

        @group = Group.find(@group_id)

        #Usuario já está no grupo
        if current_user.groups.include? @group
            return render json: "{}", status: 403
        end

        #Já mandou um convite
        if current_user.invite_groups.include? @group
            return render json: "{}", status: 403
        end

        Invite.create(user_id: current_user.id, group_id: @group_id)

        return render json: "{}", status: 201
    end

    def show
        @user_id = params[:user_id]

        if !User.exists?(id: @user_id)
            return render json: "{}", status: 404
        end

        @user = User.find(@user_id)

        return render json: @user.groups, status: 200
    end

    def get_groups
        @user = current_user

        return render json: @user.groups, status: 200
    end

    def delete
        @group_id = params[:group_id]

        if !Group.exists?(id: @group_id)
            return render json: "{}", status: 404
        end

        @group = Group.find(@group_id)

        @usergroups = @group.user_groups

        @gid = @group.id

        @group.destroy
        @usergroups.destroy

        render json: {group: Group.with_deleted.find(@gid)}, status: 200
    end

    def create
        @group = Group.new(group_params)
        @group.owner_id = current_user.id

        if @group.save
            @usergroup = UserGroup.create(group_id: @group.id, user_id: @group.owner_id)
            render json: {group: @group, usergroup: @usergroup}, status: :created
        else
            render json: @group.errors, status: 404
        end
        
    end

    private

    def group_params
        params.require(:group).permit(:name, :category, :private)
    end
end