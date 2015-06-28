class ScoresParser
	def get_user_song_scores(user,song)
		page = 1
	    has_next_page = true

	    while has_next_page do
	      url = ApplicationHelper.get_player_scores(user.server_id,song.server_id,page)
	      page = page + 1
	      @content = ""
	      doc = Nokogiri::HTML(open(url))
	      paginator_next = doc.xpath('/html/body/div/div[2]/div[2]/div[3]/*[last()]')
	      if paginator_next != nil && paginator_next.children[0].content == "next" then
	        xpath = '/html/body/div/div[2]/div[2]/div[4]/div[2]/table/tr[position()>1]'
	        if paginator_next.attribute('class') != nil && paginator_next.attribute('class').value.index("disabled") != nil then
	          has_next_page = false
	        else
	          has_next_page = true
	        end
	      else
	        xpath = '/html/body/div/div[2]/div[2]/div[3]/div[2]/table/tr[position()>1]'
	        has_next_page = false
	      end
	      doc.xpath(xpath).each do |tr|  
	        children = tr.children
	        match_id = children[3].content.to_i
	        user_score = UserScore.find_by server_id: match_id
	        if user_score == nil then
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

	            if song.server_difficulty_name.downcase == difficulty_name.downcase && song.server_difficulty_number.downcase == difficulty_number.downcase then
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
	              user_score.song = song
	              user_score.save
	            else

	            end
	          end
	        else
	          user_score.user = user
	          user_score.song = song
	          user_score.server_date = date.in_time_zone
	          user_score.save
	        end
	      end
	      
	    end

	    return
	end
end