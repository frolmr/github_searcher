# frozen_string_literal: true

require_relative '../services/github_searcher'

class SearchController < Sinatra::Base
  configure do
    set :views, 'app/views'
  end

  get '/search/:subject' do
    @subject = params[:subject]
    erb :search, locals: { search_subject: @subject }
  end

  post '/search' do
    @items = GithubSearcher.call(params)
    @subject = params[:search_subject]
    erb :search, locals: { items: @items, search_subject: @subject }
  end
end
