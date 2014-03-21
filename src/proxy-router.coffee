
http = require 'http'

httpProxy = require 'http-proxy'

class Router

	constructor: (@config) ->

		@routes = for host, address of @config.router ? {}
			
			address = address: address if 'string' is typeof address
			host = new RegExp host if address.regex?
				
			address: address.address
			matcher: host
			
	matchHost: (host) ->

		for {address, matcher} in @routes
			
			if matcher instanceof RegExp
				return address if host.match matcher
			else
				return address if host is matcher
			
		@config.defaultRoute

exports.instantiate = (config) ->

	proxy = httpProxy.createProxy()
	
	router = new Router config
	
	mergeForwardedFor = (previous, current) ->
		
		parts = if previous? then previous.split /\s*, */ else []
		parts.unshift current
		
		parts.join ', '
	
	proxyServer = http.createServer (req, res) ->
		
		unless (target = router.matchHost req.headers.host)?
			res.writeHead 502, 'Content-Type': 'text/html'
			res.end '<h1>502 Bad Gateway</h1>'
			
			return if config.silent
			return console.log "No route exists for #{req.headers.host}!"

		req.headers['x-forwarded-for'] = mergeForwardedFor(
			req.headers['x-forwarded-for']
			req.connection.remoteAddress
		)
		
		proxy.web(
			req, res
			target: target
			(error) ->
				
				res.writeHead 502, 'Content-Type': 'text/html'
				res.end '<h1>502 Bad Gateway</h1>'
				
				return if config.silent
				console.log "While proxying HTTP (#{
					target
				}): #{
					error.stack
				}"
	
		)
	
	proxyServer.on 'upgrade', (req, socket, head) ->
		
		unless (target = router.matchHost req.headers.host)?
			socket.destroy()
			
			return if config.silent
			return console.log "No route exists for #{req.headers.host}!"
		
		req.headers['x-forwarded-for'] = mergeForwardedFor(
			req.headers['x-forwarded-for']
			req.connection.remoteAddress
		)
		
		proxy.ws(
			req, socket, head
			target: router.matchHost req.headers.host
			(error) ->
				
				socket.destroy()
				
				return if config.silent
				console.log "While proxying WebSocket (#{
					target
				}): #{
					error.stack
				}"
				
		)
		
	proxyServer
