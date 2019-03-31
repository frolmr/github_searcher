# frozen_string_literal: true

require_relative 'base_service'
require 'dry-validation'

class GithubSearcherError < StandardError; end

class GithubSearcher < BaseService
  SCHEMA = Dry::Validation.Schema do
    required(:params).schema do
      required(:search_subject).filled(:str?)
      required(:keywords).filled(:str?)
    end
  end

  def initialize(params)
    @params = params
  end

  def call
    validate_input
    [1, 2, 3]
  end

  private

  def validate_input
    validation_result = SCHEMA.call(params: @params)

    raise GithubSearcherError, validation_result.messages if validation_result.failure?
  end
end
