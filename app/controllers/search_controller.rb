# frozen_string_literal: true

require_relative '../services/github_searcher'

class SearchController < Sinatra::Base
  configure do
    set :views, 'app/views'
  end

  get '/search/:search_subject' do
    @search_subject = params[:search_subject]
    @keywords = params[:keywords]

    if @keywords
      result = GithubSearcher.call(params)
      @entities = result.items
      @next  = result[:next]
      @prev  = result[:prev]
      @last  = result[:last]
      @first = result[:first]
    end

    erb :search, locals: { search_subject: @search_subject, keywords: @keywords }

  rescue GithubSearcherError, GithubRequesterError, GithubResponseDecoratorError => e
    erb :search, locals: { errors: e }
  end
end
