# kiss-proxy

## Continuing the legacy of an easy-to-use proxy server that [node-http-proxy](http://github.com/nodejitsu/node-http-proxy) started

It can be a real pain finding a dead-simple reverse proxy solution for node applications, what with nginx not being updated on
some Linux distributions (and I don't even want to think about Windows), and node-http-proxy deciding that shipping a nice
command-line utility like they used to was not a priority.

With that being said, I give you kiss-proxy, which has all the good mojo from the old original easy to use proxy, and is
**v0.10 compatible**.

## Using kiss-proxy from the command line
When you install this package with npm, a kiss-proxy binary will become available to you. Using this binary is easy with some simple options:

```
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
```

Have fun, and happy devving! <3
