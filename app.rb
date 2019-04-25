require 'sinatra'
require './presenters/home'


get '/' do
  @presenter = Presenters::Home.new(
    title: 'Nexmo Developer',
    env: Sinatra::Application.environment,
  )
  erb 'Hello World'
end
