require "uri"
module ApplicationHelper
	def resource_name
		:user
	end

	def resource
		@resource ||= User.new
	end

	def devise_mapping
		@devise_mapping ||= Devise.mappings[:user]
	end

	def self.server_url
		return "http://stepmaniaonline.net/"
	end

	def self.profile_url
		return server_url + "index.php?page=profile&uid="
	end

	def self.match_url
		return server_url + "index.php?page=match&mid="
	end

	def self.song_url
		return server_url + "index.php?page=song&sid="
	end

	def self.avatar_url
		return server_url + "images/avatars/"
	end

	def self.song_img_url
		return server_url + "images/avatars-songs/"
	end

	def self.grade_aaaa_url
		return server_url + "images/grade_AAAA.png"
	end

	def self.grade_aaa_url
		return server_url + "images/grade_AAA.png"
	end

	def self.grade_aa_url
		return server_url + "images/grade_AA.png"
	end

	def self.grade_a_url
		return server_url + "images/grade_A.png"
	end

	def self.grade_b_url
		return server_url + "images/grade_B.png"
	end

	def self.grade_c_url
		return server_url + "images/grade_C.png"
	end

	def self.grade_d_url
		return server_url + "images/grade_D.png"
	end

	def self.grade_f_url
		return server_url + "images/grade_F.png"
	end

	def self.grade_unknown_url
		return server_url + "images/grade_10.png"
	end

    def self.get_avatar_user(name,size)
    	# 無心
    	uri = URI(URI.parse(URI.encode(avatar_url + name.encode("UTF-8") + "-" + "medium.png")))
		request = Net::HTTP.new uri.host
		response= request.request_head uri.path
		exists = response.code.to_i == 200

	  	if name != nil && exists then
			if size == 1 || size == "medium" then
				return avatar_url + name.encode("UTF-8") + "-" + "medium.png"
			else
				return avatar_url + name.encode("UTF-8") + "-" + "small.png"
			end
	  	else
	  		if size == 1 || size == "medium" then
				return avatar_url + "default-medium.png"
			else
				return avatar_url + "default-small.png"
			end
	  	end
	end

	def self.get_player_scores(user_id,song_id,page)
		if page != nil then
			return profile_url + user_id.to_s + "&sid=" + song_id.to_s + "&p=" + page.to_s
		else
			return profile_url + user_id.to_s + "&sid=" + song_id.to_s
		end
	end

	def self.get_match(match_id)
		return match_url + match_id.to_s
	end

	def self.get_grade_number(resource)
		if grade_aaaa_url[resource] != nil then
			return 7
		end

		if grade_aaa_url[resource] != nil then
			return 6
		end

		if grade_aa_url[resource] != nil then
			return 5
		end

		if grade_a_url[resource] != nil then
			return 4
		end

		if grade_b_url[resource] != nil then
			return 3
		end

		if grade_c_url[resource] != nil then
			return 2
		end

		if grade_d_url[resource] != nil then
			return 1
		end

		if grade_f_url[resource] != nil then
			return 0
		end

		return -1

	end

	def self.get_grade_image(number)
		if number == 7 then
			return grade_aaaa_url
		end

		if number == 6 then
			return grade_aaa_url
		end

		if number == 5 then
			return grade_aa_url
		end

		if number == 4 then
			return grade_a_url
		end

		if number == 3 then
			return grade_b_url
		end

		if number == 2 then
			return grade_c_url
		end

		if number == 1 then
			return grade_d_url
		end

		if number == 0 then
			return grade_f_url
		end

		return grade_unknown_url
	end

	def self.get_song_server_url(song_id)
		return song_url + song_id.to_s
	end

	def self.get_profile_server_url(user_id)
		return profile_url + user_id.to_s
	end

	def self.get_match_server_url(match_id)
		return match_url + match_id.to_s
	end

	def self.get_song_server_img(song_id,size)
		uri = URI(song_img_url + song_id.to_s + "-" + "medium.png")
		request = Net::HTTP.new uri.host
		response= request.request_head uri.path
		exists = response.code.to_i == 200
	  	if name != nil && exists then
			if size == 1 || size == "medium" then
				return song_img_url + song_id.to_s + "-" + "medium.png"
			else
				return song_img_url + song_id.to_s + "-" + "small.png"
			end
	  	else
	  		if size == 1 || size == "medium" then
				return avatar_url + "default-medium.png"
			else
				return avatar_url + "default-small.png"
			end
	  	end
	end
end
