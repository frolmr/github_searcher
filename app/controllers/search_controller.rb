# frozen_string_literal: true

class SearchController < Sinatra::Base
  configure do
    set :views, 'app/views'
  end

  get '/search/:subject' do
    @subject = params[:subject]
    erb :search, locals: { search_subject: @subject }
  end

  post '/search' do
    @items = params[:keywords].split(' ')
    @subject = params[:search_subject]
    erb :search, locals: { items: @items, search_subject: @subject }
  end
end
