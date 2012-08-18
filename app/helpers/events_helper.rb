module EventsHelper
	def get_facebook_image object_id , type = 'square' #can be square, small, normal, or large
		"http://graph.facebook.com/#{object_id}/picture?type=#{type}"
	end
end
