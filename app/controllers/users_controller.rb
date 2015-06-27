class UsersController < ApplicationController
  load_and_authorize_resource find_by: :server_id
  before_action :set_user, only: [:show]

  # GET /users
  # GET /users.json
  def index
    @order = 'name'
    @users = User.order("LOWER(name)").page params[:page]
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
    @user = User.find_by server_id: params[:id]
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
    @user = User.find_by server_id: params[:id]
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
    @user = User.find_by server_id: params[:id]
    @relationship = current_user.friends_request.where("user_one_id =? OR user_two_id =?", @user.id, @user.id).first
    @relationship.status = 1
    respond_to do |format|
      if @relationship.save then
        format.html { redirect_to action: "show", id: @user.server_id, notice: 'Solicitud aceptada.' }
      end
    end
  end

  def propose_song_show
    @user = User.find_by server_id: params[:id]
    @songs = Song.order(:name).page params[:page]
    @relationship = current_user.friends.where("user_one_id =? OR user_two_id =?", @user.id, @user.id).first
    if @relationship != nil then
      @relationship_songs = @relationship.songs
    else
      @relationship_songs = nil
    end
    render "propose_song"
  end

  def propose_song_post
    @relationship_song = RelationshipSong.new
    @user = User.find_by id: params[:userid]
    @song = Song.find_by id: params[:songid]
    @relationship = current_user.friends.where("user_one_id =? OR user_two_id =?", @user.id, @user.id).first
    @relationship_song.relationship = @relationship
    @relationship_song.song = @song
    respond_to do |format|
      if @relationship_song.save then
        format.html { redirect_to action: "show", id: @user.server_id, notice: 'Cancion propuesta!' }
      else
        format.html { redirect_to action: "show", id: @user.server_id, notice: 'Errores.' }
      end
    end
  end

  def propose_song_delete
    
    @user = User.find_by id: params[:userid]
    @song = Song.find_by id: params[:songid]
    @relationship = current_user.friends.where("user_one_id =? OR user_two_id =?", @user.id, @user.id).first
    @relationship_song = RelationshipSong.where("relationship_id =? AND song_id =?", @relationship.id, @song.id).first
    respond_to do |format|
      if @relationship_song.delete then
        format.html { redirect_to action: "show", id: @user.server_id, notice: 'Cancion eliminada!' }
      else
        format.html { redirect_to action: "show", id: @user.server_id, notice: 'Errores.' }
      end
    end
  end

  def publish_comment_show
    @comments = @user.comments.order(created_at: :desc).page params[:page];
    render "publish_comment"
  end

  def publish_comment_post
    comment = Comment.new
    comment.author = current_user;
    comment.user = @user;
    comment.comment = params[:message];
    respond_to do |format|
      if comment.save then
        format.html { redirect_to action: "publish_comment_show", id: @user.server_id, notice: 'Comentario creado' }
      else
        format.html { redirect_to action: "publish_comment_show", id: @user.server_id, notice: 'Errores.' }
      end
    end
  end

  def publish_comment_delete
    # unimplemented
    @relationship_song = RelationshipSong.new
    @user = User.find_by id: params[:userid]
    @song = Song.find_by id: params[:songid]
    @relationship = current_user.friends.where("user_one_id =? OR user_two_id =?", @user.id, @user.id).first
    @relationship_song.relationship = @relationship
    @relationship_song.song = @song
    respond_to do |format|
      if @relationship_song.save then
        format.html { redirect_to action: "show", id: @user.server_id, notice: 'Cancion propuesta!' }
      else
        format.html { redirect_to action: "show", id: @user.server_id, notice: 'Errores.' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by server_id: params[:id]
      if current_user != nil && @user != current_user then
        @relationship = current_user.friends.where("user_one_id =? OR user_two_id =?", @user.id, @user.id).first
        if @relationship != nil then
          @relationship_songs = @relationship.songs
        else
          @relationship_songs = nil
        end
      end
    end

    def user_params
      params.require(:user).permit(:name, :server_difficulty_name, :server_difficulty_number, :server_id)
    end
end
