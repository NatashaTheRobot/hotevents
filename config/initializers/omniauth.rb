Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '338513749570080', 'a899cba3a0a91fb956ae0d745a0f1fc8', scope: "user_events, friends_events, friends_location, rsvp_event, offline_access"
end