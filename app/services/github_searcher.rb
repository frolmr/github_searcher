# frozen_string_literal: true

require_relative 'base_service'
require_relative 'uri_builder'
require_relative 'github_requester'
require_relative 'decorators/github_response_decorator'
require 'dry-validation'

class GithubSearcherError < StandardError; end

class GithubSearcher < BaseService
  SCHEMA = Dry::Validation.Schema do
    required(:params).schema do
      required(:search_subject, :string).filled(format?: /(users|repositories)/)
      required(:keywords).filled(:str?)
      optional(:page).maybe(:str?)
    end
  end

  def initialize(params)
    @params = params
  end

  def call
    validate_input
    search_subject = @params[:search_subject]
    keywords = fetch_keywords(@params[:keywords])
    page_number = @params[:page] || '1'
    uri = UriBuilder.call(search_subject, keywords, page_number)
    github_response = GithubRequester.call(uri)
    GithubResponseDecorator.call(github_response)
  end

  private

  def validate_input
    validation_result = SCHEMA.call(params: @params)

    raise GithubSearcherError, validation_result.messages if validation_result.failure?
  end

  def fetch_keywords(words_separated_by_space)
    words_separated_by_space.split(' ')
  end
end
