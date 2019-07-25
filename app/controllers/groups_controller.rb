class GroupsController < ApplicationController
    before_action :authenticate_user!, only: [:create, :show, :deleted]

    def show
        @user = User.find(params[:user_id])

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
        params.require(:group).permit(:name, :category)
    end
end