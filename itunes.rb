require 'appscript'; include Appscript
require 'lastfm'
itunes = app('iTunes')
title_old = ""
lastfm = Lastfm.new("447770d42fbd35cee967957143c434b2", "4afec6da9e6ee17be152697c0411b4d7")
#token = lastfm.auth.get_token
#token = "6827eb9ea211d2c508ca46ddb5d171fc"
#open 'http://www.last.fm/api/auth/?api_key=447770d42fbd35cee967957143c434b2&token=235066c824aeedc6dbc7318839f1fb0c'
#session = lastfm.auth.get_session(:token => token)['key']
session = "e317c683a4e12d355aefa0db23af7916"
lastfm.session = session

while true
	title_new = itunes.current_stream_title.get
	if title_new == title_old
		sleep(10)
	else
		text = title_new.gsub(/\| FM4.*/, "")
		artist = text.split(" - ").first
		track = text.split(" - ").last
		title_old = title_new 
		if artist != "FM4: You're at home baby" || track != "FM4: You're at home baby"
			puts "#{artist} - #{track}"
			lastfm.track.scrobble(:artist => artist, :track => track)
		end
	end
end