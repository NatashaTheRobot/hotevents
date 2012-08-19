module EventsHelper
	def get_facebook_image object_id , type = 'square' #can be square, small, normal, or large
		"http://graph.facebook.com/#{object_id}/picture?type=#{type}"
	end

	def date_from_facebook date_str
		#ISO-8601 
		Time.parse(date_str).strftime("%A, %B %d, %Y")
	end
end