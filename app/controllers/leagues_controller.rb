class LeaguesController < ApplicationController
  before_action :set_league, only: [:show, :edit, :update, :destroy, :add_song_show]

  # GET /leagues
  # GET /leagues.json
  def index
    @leagues = League.all
  end

  # GET /leagues/1
  # GET /leagues/1.json
  def show
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

  def join_league_post
    @user = User.find_by id: params[:userid]
    @league = League.find_by id: params[:leagueid]
    if Time.now > @league.start_date then
      redirect_to action: "index", notice: 'Error: La liga ya empezo.'
      return
    end
    @contestant = Contestant.new
    @contestant.user = @user
    @contestant.league = @league
    respond_to do |format|
      if @contestant.save then
        format.html { redirect_to action: "show", id: @league.id, notice: 'Te uniste a la liga.' }
      else
        format.html { redirect_to action: "index", notice: 'Errores.' }
      end
    end
  end

  def join_league_delete
    @user = User.find_by id: params[:userid]
    @league = League.find_by id: params[:leagueid]
    if Time.now >= @league.finish_date then
      redirect_to action: "show", id: @league, notice: 'La liga ya ha terminado, no puedes salirte.'
      return
    end
    @contestant = @league.contestants.where("user_id =?", @user.id).first
    respond_to do |format|
      if @contestant.destroy then
        format.html { redirect_to action: "show", id: @league, notice: 'Te saliste de la liga.' }
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
        format.html { redirect_to action: "add_song_show", id: @league_song.league_id, notice: 'Cancion eliminada correctamente.' }
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
        format.html { redirect_to action: "show", id: @league, notice: 'Factor modificado correctamente.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_league
      @league = League.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def league_params
      params.require(:league).permit(:name, :description, :start_date, :finish_date)
    end
end
