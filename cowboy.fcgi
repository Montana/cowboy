#!/opt/ruby2.2.2/bin/ruby-2.2.4
require 'rubygems'
require 'rack'
require 'sinatra'
 
require 'start'
Rack::Handler::FastCGI.run Sinatra::Application
