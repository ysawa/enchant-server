# -*- coding: utf-8 -*-

require './config/initialize'
require 'sinatra'

get '/' do
  haml :index
end

get '/app.css' do
  sass :app
end

not_found do
  "Page Not Found"
end

error 403 do
  "Invalid Format"
end

set :haml, { ugly: true, format: :html5 }
set :public_folder, File.dirname(__FILE__) + '/public'

configure do
  use Rack::Session::Cookie, key: 'rack.session',
                             domain: 'enchant.yoshihirosawa.com',
                             path: '/',
                             expire_after: 2592000,
                             secret: '1814c15c3a4404de97a67a39f4b1a638'
  use Rack::Csrf, raise: true, skip: ['POST:/']
end

helpers do
  def csrf_token
    Rack::Csrf.csrf_token(env)
  end

  def csrf_tag
    Rack::Csrf.csrf_tag(env)
  end

  def number_with_delimiter(number)
    parts = number.to_s.to_str.split('.')
    parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
    parts.join('.')
  end

  def partial(renderer, template, options = {})
    options = options.merge({layout: false})
    template = template.to_s.sub(/(\/|^)(\w+)$/, '\1_\2').to_sym
    method(renderer).call(template, options)
  end

  def partial_erb(template, options)
    partial(:erb, template, options)
  end

  def partial_haml(template, options = {})
    partial(:haml, template, options)
  end
end
