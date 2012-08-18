module FacebookEvents
	require 'koala'
	FB_APP_ID = ""
	FB_SECRET = ""
	class Event
		attr_accessor :name , :start_time, :end_time , :timezone , :location , :fb_event_id
		attr_accessor :rsvps #this will be an array of Rsvp objects

		def initialize args = {}
			args.each do |k,v|
        		instance_variable_set("@#{k}",v) unless v.nil?
      		end
			#@rsvps = [].push( Rsvp.new( { :name =>  } ) )
		end
	end
	class Rsvp
		attr_accessor :name , :facebook_id , :status
		def initialize args = {}
			instance_variable_set("@#{k}",v) unless v.nil?
		end
	end

	class FacebookRequests
		attr_accessor :oatuh_token

		def initialize oauth_token
			@graph = Koala::Facebook::API.new(oauth_token)
		end

		def get_user_events user_id , max_events = 50
			#TODO: if there are more than 500, keep looping through
			@graph.get_connections( user_id , "events?since=0&limit=#{max_events}" )
		end

		def get_multiple_users_events user_ids
			user_ids = user_ids[0..50] #limit to 50 user_ids
			events = @graph.batch do |batch_api|
				user_ids.each{ |uid| 
					batch_api.get_connections( uid , "events?since=0&limit=500" ) 
				}
			end
			all_events = []
			events.each{|event|
				all_events = all_events + event
			}
			all_events
		end

		def get_all_event_rsvps fb_event_id
			rsvps = @graph.batch do |batch_api|
				batch_api.get_object( "#{fb_event_id}/attending" )
				batch_api.get_object( "#{fb_event_id}/declined" )
				batch_api.get_object( "#{fb_event_id}/maybe" )
				batch_api.get_object( "#{fb_event_id}/invited" )
			end
			return { :attending => rsvps[0] , :declined => rsvps[1] , :maybe => rsvps[2] , :invited => rsvps[3] }
		end

		def get_user_friends user_id
			@graph.get_object("#{user_id}/friends")
		end

		def get_user_friend_ids user_id
			all_friends = self.get_user_friends user_id
			friends = []
			all_friends.each{ |friend| friends.push(friend["id"]) }
			friends
		end

		def get_user_likes user_id
			@graph.get_connections("me", "likes")
		end
	end

	class DirtyFacebook
		def initialize
			@user_id = "7403766"
			@token =  "AAAEz4FZCLciABAAVZCD4BslHy5KfF2hotWSv0MzDX8QIJmEE6So4WPNxrOoJ6I4pY7xPQCqckYj4SXDH6L41ZBrGE2hrjwvZA68oK2NJVQZDZD"
		end
		def check_rsvps_for_friends rsvps , friends
			matched_friends = []
			rsvps.each{|rsvp| matched_friends.push(rsvp['id']) if friends.include? rsvp['id']  }
			matched_friends
		end
		def get_event_stubs num_stubs
			@fb = FacebookEvents::FacebookRequests.new( @token )
			#get Nick's friends
			friend_ids = @fb.get_user_friend_ids @user_id
			#get Nick's events
			events = @fb.get_user_events @user_id , num_stubs
			#get RSVPs for the events
			events.each{|event| 
				rsvps = @fb.get_all_event_rsvps event["id"]
				friends = self.check_rsvps_for_friends rsvps[:attending] , friend_ids
				friends = friends + self.check_rsvps_for_friends(rsvps[:maybe] , friend_ids) if friends.count < 5
				friends = friends + self.check_rsvps_for_friends(rsvps[:invited] , friend_ids) if friends.count < 5
				event["friends"] = friends
				event['friends'] = friends[0..4] if friends.count > 5
				#add teaser string based on # of friends
			}
			return events
		end
	end
end


@fb = FacebookEvents::DirtyFacebook.new
p @fb.get_event_stubs 60

#crawl through my events
#get friends
#get each friends' events
#get users' likes
#get users' likes' events
#foreach event get rsvps

# Users (:user_id, :email, :facebook_id, :oauth_token, :oauth_expiration)
# Events (:event_id , :name , :start_time, :end_time , :timezone , :location , :fb_event_id)
# User_events (:user_id , :event_id , :rsvp_status , :teaser_users, :num_friends_attending, :num_friends_maybe , :num_friends_invited)
