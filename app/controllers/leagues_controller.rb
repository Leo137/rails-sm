require 'date'
require "#{Rails.root}/app/poro/scores_parser.rb"

class LeaguesController < ApplicationController
  load_and_authorize_resource 
  before_action :set_league, only: [:show, :edit, :update, :destroy, :add_song_show, :update_scores_get, :update_scores_all_get]

  # GET /leagues
  # GET /leagues.json
  def index
    if can? :manage, @leagues
      @leagues = League.all
    else
      @leagues = League.all.where(visible: true)
    end
  end

  # GET /leagues/1
  # GET /leagues/1.json
  def show
    render "show"
  end

  # GET /leagues/new
  def new
    @league = League.new
  end

  # GET /leagues/1/edit
  def edit
  end

  # POST /leagues
  # POST /leagues.json
  def create
    @league = League.new(league_params)

    respond_to do |format|
      @league.organizer = current_user
      if @league.save
        format.html { redirect_to @league, notice: 'League was successfully created.' }
        format.json { render :show, status: :created, location: @league }
      else
        format.html { render :new }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leagues/1
  # PATCH/PUT /leagues/1.json
  def update
    respond_to do |format|
      @league.organizer = current_user
      if @league.update(league_params)
        format.html { redirect_to @league, notice: 'League was successfully updated.' }
        format.json { render :show, status: :ok, location: @league }
      else
        format.html { render :edit }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leagues/1
  # DELETE /leagues/1.json
  def destroy
    @league.destroy
    respond_to do |format|
      format.html { redirect_to leagues_url, notice: 'League was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def publish_comment_show
    @comments = @league.comments.order(created_at: :desc).page params[:page];
    render "publish_comment"
  end

  def publish_comment_post
    comment = Comment.new
    comment.author = current_user;
    comment.league = @league;
    comment.comment = params[:message];
    respond_to do |format|
      if comment.save then
        format.html { redirect_to action: "publish_comment_show", id: @league.id, notice: 'Comentario creado' }
      else
        format.html { redirect_to action: "publish_comment_show", id: @league.id, notice: 'Errores.' }
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

  def join_league_post
    @user = User.find_by id: params[:userid]
    @league = League.find_by id: params[:leagueid]
    if (Time.now.in_time_zone > @league.start_date) && (!@league.allows_join_when_started || Time.now.in_time_zone >= @league.finish_date) then
      flash[:notice] = 'Error, la liga ya ha comenzado'
      redirect_to leagues_url
      return
    end
    @contestant = Contestant.new
    @contestant.user = @user
    @contestant.league = @league
    respond_to do |format|
      if @contestant.save then
        flash[:notice] = 'Te uniste a la liga.'
        format.html { redirect_to action: "show", id: @league.id}
      else
        flash[:notice] = 'Errores'
        redirect_to leagues_url
      end
    end
  end

  def join_league_delete
    @user = User.find_by id: params[:userid]
    @league = League.find_by id: params[:leagueid]
    if Time.now.in_time_zone >= @league.finish_date then
      flash[:notice] = 'La liga ya ha terminado, no puedes salirte.'
      redirect_to action: "show", id: @league
      return
    end
    @contestant = @league.contestants.where("user_id =?", @user.id).first
    respond_to do |format|
      if @contestant.destroy then
        flash[:notice] = 'Te saliste de la liga.'
        format.html { redirect_to action: "show", id: @league}
        format.json { head :no_content }
      end
    end
  end

  def add_song_show
    @songs = Song.order(:name).page params[:page]
    @league_songs = @league.songs
    render "add_song"
  end

  def add_song_post
    @league_song = LeagueSong.new
    @song = Song.find_by id: params[:songid]
    @league = League.find_by id: params[:leagueid]
    @league_song.league = @league
    @league_song.song = @song
    @league_song.factor = 1
    respond_to do |format|
      if @league_song.save then
        format.html { redirect_to action: "show", id: @league.id, notice: 'Cancion Añadida!' }
      else
        format.html { redirect_to action: "show", id: @league.server_id, notice: 'Errores.' }
      end
    end
  end

  def add_song_put
    @league_song = LeagueSong.find_by id: params[:leaguesongid]
    @league_song.factor = params[:factor]
    respond_to do |format|
      if @league_song.save then
        format.html { redirect_to action: "add_song_show", id: @league_song.league_id, notice: 'Factor modificado correctamente' }
        format.json { head :no_content }
      end
    end
  end

  def add_song_delete
    @song = Song.find_by id: params[:songid]
    @league = League.find_by id: params[:leagueid]
    @league_song = @league.league_songs.where("song_id =?", @song.id).first
    respond_to do |format|
      if @league_song.destroy then
        format.html { redirect_to action: "show", id: @league, notice: 'Cancion eliminada correctamente.' }
        format.json { head :no_content }
      end
    end
  end

  def update_scores_get
    user = User.find(params[:userid])
    league_song = @league.songs
    sp = ScoresParser.new
    league_song.each do |song|
      sp.get_user_song_scores(user,song)
    end
    flash[:notice] = 'Puntuaciones actualizadas.'
    redirect_to @league
  end

  def update_scores_all_get
    league_song = @league.songs
    users = @league.users
    sp = ScoresParser.new
    users.each do |user|
      league_song.each do |song|
        sp.get_user_song_scores(user,song)
      end
    end
    flash[:notice] = 'Puntuaciones actualizadas.'
    redirect_to @league
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_league
      @league = League.find(params[:id])
      @start_date = @league.start_date.in_time_zone.strftime('%d/%m/%Y %I:%M %p')
      @finish_date = @league.finish_date.in_time_zone.strftime('%d/%m/%Y %I:%M %p')
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def league_params
      format = "%m/%d/%Y%n%l:%M%n%p"
      if params[:league][:start_date].is_a?(String) && params[:league][:finish_date].is_a?(String) then
        params[:league][:start_date] = DateTime.strptime(params[:league][:start_date], format).change(:offset => DateTime.now.in_time_zone.zone)
        params[:league][:finish_date] = DateTime.strptime(params[:league][:finish_date],format).change(:offset => DateTime.now.in_time_zone.zone)
      end
      params.require(:league).permit(:name, :description, :start_date, :finish_date, :allows_join_when_started, :scoring_mode, :visible)
    end
end
