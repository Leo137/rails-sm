class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  # GET /users
  # GET /users.json
  def index
    @order = 'name'
    @users = User.order(:name).page params[:page]
  end

  def index_rank
    @order = 'rank'
    @users = User.order(:name).page params[:page]
    render "index"
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  def friend_request_show
    @friends = current_user.friends
    @requests = current_user.friends_request
    render "friend_request"
  end

  def friend_request_post
    @relationship = Relationship.new
    @user = User.find_by id: params[:id]
    @relationship.user_one_id = current_user.id
    @relationship.user_two_id = @user.id
    @relationship.status = 0
    respond_to do |format|
      if @relationship.save then
        format.html { redirect_to action: "show", id: @user.server_id, notice: 'Solicitud enviada.' }
      else
        format.html { redirect_to action: "show", id: @user.server_id, notice: 'Errores.' }
      end
    end
  end

  def friend_request_delete
    @user = User.find_by id: params[:id]
    @relationship = current_user.friends_all.where("user_one_id =? OR user_two_id =?", @user.id, @user.id).first
    @status = @relationship.status
    respond_to do |format|
      if @relationship.destroy then
        if @status == 0 then
          format.html { redirect_to action: "show", id: @user.server_id, notice: 'Solicitud cancelada.' }
        else
          format.html { redirect_to action: "show", id: @user.server_id, notice: 'Amistad eliminada.' }
        end
      end
    end
  end

  def friend_request_put
    @user = User.find_by id: params[:id]
    @relationship = current_user.friends_request.where("user_one_id =? OR user_two_id =?", @user.id, @user.id).first
    @relationship.status = 1
    respond_to do |format|
      if @relationship.save then
        format.html { redirect_to action: "show", id: @user.server_id, notice: 'Solicitud aceptada.' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by server_id: params[:id]
    end

    def user_params
      params.require(:user).permit(:name, :server_difficulty_name, :server_difficulty_number, :server_id)
    end
end
