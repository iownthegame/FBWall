require 'json'
class HomeController < ApplicationController
	include RestGraph::RailsUtil
	before_filter :login_facebook#, :only => [:login]
	
	def index
		@access_token = rest_graph.access_token
		if @access_token
			@me = rest_graph.get('/me')
			@feed = rest_graph.get('/me/home')  #News feed

			@rst = JSON[@feed["data"]]
			@rst2 = JSON.parse(@rst)
			@photo = []
			@video = []
			@status = []
			@link = []
			@checkin = []
			@swf = []
			#puts @rst2.to_s
			@rst2.each do |msg|
				@type = msg["type"]
				if (@type == "photo")
					@photo.push(msg)
				elsif(@type == "video")
					@video.push(msg)
				elsif(@type == "status")
					@status.push(msg)
				elsif(@type == "link")
					@link.push(msg)
				elsif(@type == "checkin")
					@checkin.push(msg)
				elsif(@type == "swf")
					@swf.push(msg)
				end
			end
		end
	end

private
	def login_facebook
		reset_session
		rest_graph_setup(:auto_authorize	=> true,
				 :auto_authorize_scope  => 'read_stream',
				 :ensure_authorized     => true,
				 :write_session		=> true	)
	end
end
