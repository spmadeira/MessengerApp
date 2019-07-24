class GroupsController < ApplicationController
    before_action :authenticate_user!, only: [:create]

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