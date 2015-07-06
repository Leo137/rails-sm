class StairwaysController < ApplicationController
  load_and_authorize_resource
  before_action :set_stairway, only: [:show, :edit, :update, :destroy, :update_scores_get, :publish_comment_show, :publish_comment_post]

  # GET /stairways
  # GET /stairways.json
  def index
    @stairways = Stairway.all
  end

  # GET /stairways/1
  # GET /stairways/1.json
  def show
    @stairway_songs = @stairway.stairway_songs.page params[:page]
  end

  # GET /stairways/new
  def new
    @stairway = Stairway.new
  end

  # GET /stairways/1/edit
  def edit
  end

  # POST /stairways
  # POST /stairways.json
  def create
    @stairway = Stairway.new(stairway_params)
    @stairway.user = current_user
    respond_to do |format|
      if @stairway.save
        format.html { redirect_to @stairway, notice: 'Stairway was successfully created.' }
        format.json { render :show, status: :created, location: @stairway }
      else
        format.html { render :new }
        format.json { render json: @stairway.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stairways/1
  # PATCH/PUT /stairways/1.json
  def update
    @stairway.user = current_user
    respond_to do |format|
      if @stairway.update(stairway_params)
        format.html { redirect_to @stairway, notice: 'Stairway was successfully updated.' }
        format.json { render :show, status: :ok, location: @stairway }
      else
        format.html { render :edit }
        format.json { render json: @stairway.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stairways/1
  # DELETE /stairways/1.json
  def destroy
    @stairway.destroy
    respond_to do |format|
      format.html { redirect_to stairways_url, notice: 'Stairway was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_song_show
    @songs = Song.order(:name).page params[:page]
    @stairway_songs = @stairway.songs
    render "add_song"
  end

  def add_song_post
    @stairway_song = StairwaySong.new
    @song = Song.find_by id: params[:songid]
    @stairway = Stairway.find_by id: params[:stairwayid]
    @stairway_song.stairway = @stairway
    @stairway_song.song = @song
    @stairway_song.points = 1.0
    @stairway_song.rate = 1.0
    respond_to do |format|
      if @stairway_song.save then
        format.html { redirect_to action: "add_song_show", id: @stairway.id, notice: 'Cancion Añadida!' }
      else
        format.html { redirect_to action: "add_song_show", id: @stairway.id, notice: 'Errores.' }
      end
    end
  end

  def add_song_put
    @stairway_song = StairwaySong.find_by id: params[:stairwaysongid]
    @stairway_song.points = params[:points]
    @stairway_song.type_song = params[:type_song]
    respond_to do |format|
      if @stairway_song.save then
        flash[:notice] = 'Song edited.'
        format.html { redirect_to action: "add_song_show", id: @stairway_song.stairway_id }
        format.json { head :no_content }
      end
    end
  end

  def add_song_delete
    @song = Song.find_by id: params[:songid]
    @stairway = Stairway.find_by id: params[:stairwayid]
    @stairway_song = @stairway.stairway_songs.where("song_id =?", @song.id).first
    respond_to do |format|
      if @stairway_song.destroy then
        flash[:notice] = 'Song removed from stairway.'
        format.html { redirect_to action: "add_song_show", id: @stairway }
        format.json { head :no_content }
      end
    end
  end

  def update_scores_get
    user = User.find(params[:userid])
    stairway_song = @stairway.songs
    sp = ScoresParser.new
    stairway_song.each do |song|
      sp.get_user_song_scores(user,song)
    end
    flash[:notice] = 'Puntuaciones actualizadas.'
    redirect_to @stairway
  end

  def ranking_show
    users = User.all
    scores = {}
    @stairway.stairway_songs.order(points: :asc).each do |stairway_song|
      song = stairway_song.song
      users.each do |user|
        if scores[user.server_id] == nil then
          scores[user.server_id] = {}
          scores[user.server_id]["server_id"] = user.server_id
          scores[user.server_id]["records"] = []
          scores[user.server_id]["totalpoints"] = 0
          scores[user.server_id]["count"] = 0
        end
        score = nil
        if song.server_migs_dp_max != nil then
          score = user.user_scores.where("song_id =? AND server_migs_dp_max >=?", song.id,song.server_migs_dp_max).order(server_migs_dp_obtained: :desc).first
        else
          score = user.user_scores.where("song_id =?", song.id).order(server_migs_dp_obtained: :desc).first
        end
        if score != nil then
          if score.server_grade > 4 then
            scores[user.server_id]["records"].push({ "points" => stairway_song.points, "type" => stairway_song.type_song, "server_id" => song.server_id, "match_id" => score.server_id })
            scores[user.server_id]["count"] += 1
          else
          end
          scores[user.server_id]["totalpoints"] += stairway_song.points
        end
      end
    end
    users.each do |user|
      if scores[user.server_id]["count"] == 0
        scores.delete(user.server_id)
      end
    end
    @ranking = {}
    scores.each do |user|
      k = user[0]
      u = user[1]
      if u["count"] >= 4 then
        if @ranking[k] == nil then
          @ranking[k] = {}
          @ranking[k]["server_id"] = u["server_id"]
          @ranking[k]["records"] = []
          @ranking[k]["totalpoints"] = 0
          @ranking[k]["averagepoints"] = 0
          @ranking[k]["count"] = 0
        end
        type_one = 0
        type_two = 0
        u["records"] = u["records"].sort { |x,y| y["points"] <=> x["points"] }
        u["records"].each do |record|
          if record["type"] == 1 && type_one >= 2 then
          end
          if record["type"] == 2 && type_two >= 2 then
          end
          @ranking[k]["records"].push(record)
          @ranking[k]["totalpoints"] += record["points"]
          @ranking[k]["count"] += 1
          if record["type"] == 1 then
            type_one += 1
          end
          if record["type"] == 2 then
            type_two += 1
          end
        end
        if @ranking[k]["count"] >= 4 then
          p1 = @ranking[k]["records"][0]["points"]
          p2 = @ranking[k]["records"][1]["points"]
          p3 = @ranking[k]["records"][2]["points"]
          p4 = @ranking[k]["records"][3]["points"]
          @ranking[k]["averagepoints"] = p1*0.25 + p2*0.25 + p3*0.25 + p4*0.25
          @ranking[k]["records"] = @ranking[u["server_id"]]["records"][0..3]
        else
          @ranking[k] = nil
        end
      end
    end
    @ranking = @ranking.sort { |x,y| x[1]["averagepoints"] <=> y[1]["averagepoints"] }
    @sc = scores
    @ranking = Kaminari.paginate_array(@ranking).page(params[:page]).per(10)
    render "ranking"
  end

  def publish_comment_show
    @comments = @stairway.comments.order(created_at: :desc).page params[:page];
    render "publish_comment"
  end

  def publish_comment_post
    comment = Comment.new
    comment.author = current_user;
    comment.stairway = @stairway;
    comment.comment = params[:message];
    respond_to do |format|
      if comment.save then
        format.html { redirect_to action: "publish_comment_show", id: @stairway.id, notice: 'Comentario creado' }
      else
        format.html { redirect_to action: "publish_comment_show", id: @stairway.id, notice: 'Errores.' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stairway
      @stairway = Stairway.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stairway_params
      params.require(:stairway).permit(:name, :description)
    end
end
