module FacebookEvents
	require 'koala'
=begin
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
=end
	class FacebookRequests
		attr_accessor :oatuh_token

		def initialize oauth_token
			@graph = Koala::Facebook::API.new(oauth_token)
		end

		#events methods
		def get_user_events user_id , max_events = 50
			#TODO: if there are more than 500, keep looping through
			@graph.get_connections( user_id , "events?since=#{Time.now.to_i}&limit=#{max_events}" )
		end

		def get_multiple_users_events user_ids , max_events = 50 , partial_callback = nil
			all_events = []

			user_ids.flatten.each_slice(50){|uids|
				fevents_start = Time.now
				events = @graph.batch do |batch_api|
					uids.each{ |uid| 
						batch_api.get_connections( uid , "events?since=#{Time.now.to_i}&limit=#{max_events}" ) 
					}
				end
				fevents_end = Time.now
				p "Friends events time: #{(fevents_end - fevents_start)*1000} milliseconds"
				partial_callback.call(events) unless partial_callback.nil? #send off the results received so far
				
				events.each{|event|
					all_events = all_events + event
				}
			}
			all_events
		end

		def get_event_rsvps_batch event_ids , batch_api
			max = event_ids.count > 10 ? 9 : event_ids.count
			ids = event_ids[0..max]
			#can't have more than 10 event IDs
			ids.each{|id|
				batch_api.get_object( "#{id}/attending" )
				batch_api.get_object( "#{id}/declined" )
				batch_api.get_object( "#{id}/maybe" )
				batch_api.get_object( "#{id}/invited" )
			}
		end

		def get_event_rsvps fb_event_id
			rsvps = @graph.batch do |batch_api|
				self.get_event_rsvps_batch [fb_event_id] , batch_api
			end
			return { :attending => rsvps[0] , :declined => rsvps[1] , :maybe => rsvps[2] , :invited => rsvps[3] }
		end

		def get_multiple_event_rsvps event_ids
			event_rsvps = {}
			event_ids.flatten.each_slice(12){ |ids|
				rsvps = @graph.batch do |batch_api|
					self.get_event_rsvps_batch ids , batch_api
				end
				ids.each{|id|
					event_rsvps[id] = { :attending => rsvps.shift , :declined => rsvps.shift , :maybe => rsvps.shift , :invited => rsvps.shift }
				}
			}
			event_rsvps
		end

		#friends methods
		def get_user_friends user_id
			@graph.get_object("#{user_id}/friends")
		end

		def get_user_friend_ids user_id
			all_friends = self.get_user_friends user_id
			friends = []
			all_friends.each{ |friend| friends.push(friend["id"]) }
			friends
		end

		#likes methods
		def get_user_likes user_id
			@graph.get_connections("me", "likes")
		end

		#page event methods

		def get_page_events_batch page_ids , max_events = 50 , partial_callback = nil
			self.get_multiple_users_events page_ids , max_events , partial_callback
		end
	end

	class DirtyFacebook
		def initialize
			@user_id = "2913363"
			@token =  "AAACEdEose0cBAJbybW8lJQjlHRKwRLFEydYS1KQSGpCAh4NyEvKZCZBIcln4pfpi92pgTdz9yJsj5rxlRgj8RwuFpWZAMFEfZBGM9e8mvwZDZD"
		end
		def check_rsvps_for_friends rsvps , friends , max_friends = 5
			matched_friends = []
			return matched_friends if rsvps.nil? || rsvps.count < 1
			rsvps.each{|rsvp| 
				matched_friends.push(rsvp['id']) if friends.include? rsvp['id']  
				break if matched_friends.count >= max_friends
			}
			matched_friends
		end
		def get_event_stubs num_stubs
			@fb = FacebookEvents::FacebookRequests.new( @token )
			#get Nick's friends
			friends_start = Time.now
			friend_ids = @fb.get_user_friend_ids @user_id
			friends_end = Time.now
			p "Friends time: #{(friends_end - friends_start)*1000} milliseconds"
			#get Nick's events
			uevents_start = Time.now
			events = @fb.get_user_events @user_id , num_stubs
			uevents_end = Time.now
			p "Events time: #{(uevents_end - uevents_start)*1000} milliseconds"
			#get RSVPs for the events
			event_ids = []
			events.each{|event| event_ids.push(event["id"]) }
			rsvps_start = Time.now
			rsvps = @fb.get_multiple_event_rsvps event_ids
			rsvps_end = Time.now
			p "RSVPs time: #{(rsvps_end - rsvps_start)*1000} milliseconds"
			#get the friends from the RSVPs
			events.each{|event|   
				friends = self.check_rsvps_for_friends rsvps[event['id']][:attending] , friend_ids , 5
				friends = friends + self.check_rsvps_for_friends(rsvps[event['id']][:maybe] , friend_ids , 5 ) if friends.count < 5
				friends = friends + self.check_rsvps_for_friends(rsvps[event['id']][:invited] , friend_ids , 5 ) if friends.count < 5
				event['friends'] = friends
			}
			return events
		end
	end
end



#@fb = FacebookEvents::DirtyFacebook.new

#p @fb.get_event_stubs 10

#@fbe = FacebookEvents::FacebookRequests.new "AAACEdEose0cBAOnLwjwWtZBEuineZB2Kg2sEY9ujppLWVAZCLuDQjAmT8sYBzq1TZADCtwJgJJhirExhH0ZAHZCIba1RLsjZCm1Ey4TutebwwZDZD"
#friends = @fbe.get_user_friend_ids "7403766"
#@fbe.get_multiple_users_events friends[0..300] , 50 , lambda { |events| p "Events received" }

#get page events
#events_received_callback = lambda { |events| p "Page Events received" }
#events = @fbe.get_page_events_batch ["calacademy","DoloresPark","thefillmore","exploratorium","deYoungMuseum","sfmoma","computerhistory","cobbscomedyclub","36636453683","theymightbegiants"], 50 , events_received_callback
#p events.count

# Users (:user_id, :email, :facebook_id, :oauth_token, :oauth_expiration)
# Events (:event_id , :name , :start_time, :end_time , :timezone , :location , :fb_event_id)
# User_events (:user_id , :event_id , :rsvp_status , :teaser_users, :num_friends_attending, :num_friends_maybe , :num_friends_invited)
