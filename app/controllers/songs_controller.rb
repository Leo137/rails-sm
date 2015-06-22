class SongsController < ApplicationController
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

  def update_score_get
    user = User.find(params[:userid])
    url = ApplicationHelper.get_player_scores(user.server_id,@song.server_id,1)
    @content = ""
    doc = Nokogiri::HTML(open(url))
    doc.xpath('/html/body/div/div[2]/div[2]/div[3]/div[2]/table/tr[position()>1]').each do |tr|  
      children = tr.children
      match_id = children[3].content.to_i
      user_score = UserScore.find_by server_id: match_id
      if user_score == nil || true then
        if user_score == nil then
          user_score = UserScore.new
        end
        url2 = ApplicationHelper.get_match(match_id)
        doc2 =  Nokogiri::HTML(open(url2))
        doc2.xpath('/html/body/div/div[2]/div[2]/div[2]/div[2]/div[2]/table[1]').each do |table|
          children2 = table.children[1].children

          name = children2[9].children[3].content
          difficulty_string = children2[11].children[3].content
          difficulty_name = difficulty_string.scan(/[a-zA-Z]+/)[0]
          difficulty_number = difficulty_string.scan(/\d+/)[0]
          date = children2[13].children[3].content
          grade = ApplicationHelper.get_grade_number(children2[17].children[3].child["src"])
          score = children2[19].children[3].content.to_i
          migs_dp_obtained_total = children2[21].children[3].content
          migs_dp_obtained = migs_dp_obtained_total.scan(/\d+/)[0]
          migs_dp_max = migs_dp_obtained_total.scan(/\d+/)[1]
          percent = children2[23].children[3].content.to_f
          max_combo = children2[25].children[3].content.to_i
          toasty_count = children2[27].children[3].content.to_i
          timing = children2[29].children[3].content.to_i
          marvelous = children2[33].children[3].content.to_i
          perfect = children2[35].children[3].content.to_i
          great = children2[37].children[3].content.to_i
          good = children2[39].children[3].content.to_i
          bad = children2[41].children[3].content.to_i
          miss = children2[43].children[3].content.to_i
          ok = children2[45].children[3].content.to_i
          ng = children2[47].children[3].content.to_i
          mines_hit_missed = children2[49].children[3].content
          mines_hit = mines_hit_missed.scan(/\d+/)[0]
          mines_missed = mines_hit_missed.scan(/\d+/)[1]
          mods = children2[51].children[3].content

          if @song.server_difficulty_name.downcase == difficulty_name.downcase && @song.server_difficulty_number.downcase == difficulty_number.downcase then
            user_score.server_marvelous = marvelous
            user_score.server_perfects = perfect
            user_score.server_greats = great
            user_score.server_goods = good
            user_score.server_bads = bad
            user_score.server_misses = miss
            user_score.server_ok = ok
            user_score.server_ng = ng
            user_score.server_percent = percent
            user_score.server_grade = grade
            user_score.server_migs_dp_obtained = migs_dp_obtained
            user_score.server_migs_dp_max = migs_dp_max
            user_score.server_date = date
            user_score.server_toasty_count = toasty_count
            user_score.server_max_combo = max_combo
            user_score.server_mines_hit = mines_hit
            user_score.server_mines_missed = mines_missed
            user_score.server_score = score
            user_score.server_timing = timing
            user_score.server_mods = mods
            user_score.server_id = match_id
            user_score.user = user
            user_score.song = @song
            user_score.save
          else

          end
        end
      end
      # image: @content = @children[7].child["src"]
      # @i = 0
      # @children.each do |c|
      #   @content = @content + "C " + @i.to_s + ": " + c.content + "(" + c.name.to_s + ")\n"
      #   @i = @i + 1
      # end
      # match_id: @content = @children[3].content
      # date: @content = @children[5].content
      # percent: @content = @children[11].content
      # percent: @content = @children[13].content
      # percent: @content = @children[15].content
      # percent: @content = @children[17].content
      # percent: @content = @children[19].content
      # percent: @content = @children[21].content
      # percent: @content = @children[23].content
    end
    
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
