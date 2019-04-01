# frozen_string_literal: true

require_relative 'base_service'
require 'net/http'

class GithubRequesterError < StandardError; end

class GithubRequester < BaseService
  def initialize(uri)
    @uri = uri
  end

  # TODO: add response validations
  def call
    response = fetch_response
    validate_response_code(response.code)
    response
  end

  private

  def fetch_response
    Net::HTTP.get_response(@uri)
  rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
         Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
    raise GithubRequesterError, e
  end

  def validate_response_code(code)
    raise GithubRequesterError, 'bad response code from GitHub' if code != '200'
  end
end
