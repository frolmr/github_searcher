# frozen_string_literal: true

require 'sinatra'
require './app/controllers/search_controller'

set :views, (proc { File.join(root, 'app/views') })

use SearchController

get '/' do
  erb :index
end
