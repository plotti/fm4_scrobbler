require 'appscript'; include Appscript
require 'lastfm'

#LastFM Setup
api_key = "447770d42fbd35cee967957143c434b2"
secret = "4afec6da9e6ee17be152697c0411b4d7"
session = ""
lastfm = Lastfm.new(api_key, secret)
begin
	session = File.open("last_fm_session.txt").first
rescue
	token = lastfm.auth.get_token
	`open "http://www.last.fm/api/auth/?api_key=#{api_key}&token=#{token}"`
	result = lastfm.auth.get_session(:token => token)['key']
	while result == nil
		result = lastfm.auth.get_session(:token => token)['key']
		sleep(3)
	end
	session = result
	File.open("last_fm_session.txt", 'w') { |file| file.write("#{session}")}
end
lastfm.session = session

#Get Itunes
itunes = app('iTunes')

# Start Looping
title_old = ""
while true
	title_new = itunes.current_stream_title.get
	if title_new != :missing_value
		if title_new == title_old
			sleep(10)
		else
			text = title_new.gsub(/\| FM4.*/, "")
			artist = text.split(" - ").first
			track = text.split(" - ").last
			title_old = title_new 
			if !artist.downcase.include?("fm4") && !track.downcase.include?("fm4")
				puts "Scrobble: #{artist} - #{track}"
				lastfm.track.scrobble(:artist => artist, :track => track)
			end
		end
	end
end