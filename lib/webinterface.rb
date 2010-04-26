class HTTPAdmin
	require 'socket'
	def initialize(port)
		@socket=TCPServer.new('10.0.0.71', port)
	end
	def run
		loop do
			session=@socket.accept
			request = session.gets
			Thread.start(session,request) do |session,request|
				self.serve(session,request)
			end
		end
	end
	def serve(session,request)
		session.print "HTTP/1.1 200/OK\r\nServer: RIRCBot\r\nContent-type: text\\html\r\n\r\ntest"
	end
end
