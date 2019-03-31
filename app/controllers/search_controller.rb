# frozen_string_literal: true

class SearchController < Sinatra::Base
  configure do
    set :views, 'app/views'
  end

  post '/search' do
    @items = [1, 2, 3]
    erb :index, locals: { item: @items }
  end
end
