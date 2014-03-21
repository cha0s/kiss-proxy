#!/usr/local/bin/coffee

fs = require 'fs'
util = require 'util'

httpProxy = require 'http-proxy'

proxyRouter = require './proxy-router'

{argv} = require 'optimist'

help = """
usage: kiss-proxy [options]

Starts a kiss-proxy server using the specified command-line options

options:
  --port   PORT       Port that the proxy server should run on
  --host   HOST       Host that the proxy server should run on
  --target HOST:PORT  Location of the server the proxy will target
  --silent            Silence the log output from the proxy server
  --user   USER       User to drop privileges to once server socket is bound
  
  --config OUTFILE    Location of the JSON configuration file for the proxy
                      server. All above options may be specified in the config
                      file but will be overridden by command-line arguments
  
  -h, --help          You're staring at it
"""

if argv.h or argv.help or Object.keys(argv).length is 2

	util.puts help
	process.exit 0

if argv.config

	try
		
		data = fs.readFileSync argv.config
		config = JSON.parse data.toString()
	
	catch error
		
		util.puts "While parsing configuration: #{error.stack}"
		process.exit 1

config ?= {}
config.host = argv.host ? config.host
config.port = argv.port ? (config.port ? 80)
config.silent = argv.silent ? config.silent
config.target = argv.target ? config.target
config.user = argv.user ? config.user

proxyServer = if config.target
	
	# Single target.
	httpProxy.createProxyServer config
	
else if config.router
	
	# Host-based routing.
	proxyRouter.instantiate config
	
else
	
	util.puts help
	process.exit 0

# Listen.
args = [config.port]
args.push config.host if config.host?

fn = -> util.puts "Proxie server now listening on port: #{config.port}"
args.push fn unless config.silent

proxyServer.listen.apply proxyServer, args

# Drop privileges (recommended).
process.setuid config.user if config.user?
