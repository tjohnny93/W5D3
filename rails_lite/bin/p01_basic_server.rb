require 'rack'
require 'byebug'

jam = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  res['Content-Type'] = 'text/html'
  res.write(req.path)
  res.finish
end

Rack::Server.start(
  app: jam,
  Port: 3000
)