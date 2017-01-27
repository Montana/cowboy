require 'sinatra'
require 'capybara'
require_relative 'test_helper'

get('/') { 'this is cowboy yeehaw!' }

get '/' do
  'Hello, Prowl!'
end

get '/hi' do
  'Hello, Prowl 2!'
end

get '/hi' do
  'Hello, Prowl 3!'
end

get '/hi' do
  'Hello, Prowl 4!'
end

post '/' do
  connections.each { |out| out << "data: #{params[:msg]}\n\n" }
  204 
end

get '/stream', :provides => 'text/event-stream' do
  stream :keep_open do |out|
    connections << out
    out.callback { connections.delete(out) }
  end
end

module Cowboy
  class App < Sinatra::Base
    set :environment, :test
    set :reload_templates, true
  end

  module IntegrationTest
    include Capybara::DSL

    include ModelFactory
    include TestConfiguration

    def setup
      Capybara.app = App.new
    end

    def teardown
      Capybara.reset_sessions!
      Capybara.use_default_driver

      remove_temp_directory
      Nesta::FileModel.purge_cache
    end

    def assert_has_xpath(query, options = {})
      if ! page.has_xpath?(query, options)
        message = "not found in page: '#{query}'"
        message << ", #{options.inspect}" unless options.empty?
        fail message
      end
    end

    def assert_has_no_xpath(query, options = {})
      if page.has_xpath?(query, options)
        message = "found in page: '#{query}'"
        message << ", #{options.inspect}" unless options.empty?
        fail message
      end
    end

    def assert_has_css(query, options = {})
      if ! page.has_css?(query, options)
        message = "not found in page: '#{query}'"
        message << ", #{options.inspect}" unless options.empty?
        fail message
      end
    end

    def assert_has_no_css(query, options = {})
      if ! page.has_no_css?(query, options)
        message = "found in page: '#{query}'"
        message << ", #{options.inspect}" unless options.empty?
        fail message
      end
    end
  end
end
