require "#{Rails.root}/app/poro/scores_parser.rb"

class SongsController < ApplicationController
  load_and_authorize_resource 
  before_action :set_song, only: [:show, :edit, :update, :destroy, :update_score_get]

  # GET /songs
  # GET /songs.json
  def index
    @songs = Song.all
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
  end

  # GET /songs/new
  def new
    @song = Song.new
  end

  # GET /songs/1/edit
  def edit
  end

  # POST /songs
  # POST /songs.json
  def create
    @song = Song.new(song_params)

    respond_to do |format|
      if @song.save
        format.html { redirect_to @song, notice: 'Song was successfully created.' }
        format.json { render :show, status: :created, location: @song }
      else
        format.html { render :new }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to @song, notice: 'Song was successfully updated.' }
        format.json { render :show, status: :ok, location: @song }
      else
        format.html { render :edit }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song.destroy
    respond_to do |format|
      format.html { redirect_to songs_url, notice: 'Song was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def publish_comment_show
    @comments = @song.comments.order(created_at: :desc).page params[:page];
    render "publish_comment"
  end

  def publish_comment_post
    comment = Comment.new
    comment.author = current_user;
    comment.song = @song;
    comment.comment = params[:message];
    respond_to do |format|
      if comment.save then
        format.html { redirect_to action: "publish_comment_show", id: @song.id, notice: 'Comentario creado' }
      else
        format.html { redirect_to action: "publish_comment_show", id: @song.id, notice: 'Errores.' }
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

  def update_score_get
    user = User.find(params[:userid])
    sp = ScoresParser.new
    sp.get_user_song_scores(user,@song)
    redirect_to @song, notice: @content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def song_params
      params.require(:song).permit(:name, :server_difficulty_name, :server_difficulty_number, :server_id)
    end
end
