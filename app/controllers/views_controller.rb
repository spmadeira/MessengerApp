class ViewsController < ApplicationController
    before_action :authenticate_user!, only: [:main]

    def main
        @user = current_user
        @groups = current_user.groups
    end

    def create_group
        @group = Group.new
    end

    def get_group
        @group = Group.find(params[:group_id])
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

end