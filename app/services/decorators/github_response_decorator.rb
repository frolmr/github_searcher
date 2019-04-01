# frozen_string_literal: true

require 'ostruct'
require_relative '../base_service'

class GithubResponseDecoratorError < StandardError; end

class GithubResponseDecorator < BaseService
  def initialize(response)
    @response = response
  end

  def call
    items = fetch_items
    page_links = fetch_pages
    create_response_object(items, page_links)
  end

  private

  def fetch_items
    JSON.parse(@response.body)['items']
  rescue JSON::ParserError => e
    raise GithubResponseDecoratorError, "response parsing error: #{e}"
  end

  def fetch_pages
    @response['Link']
      &.split(',')
      &.map { |el| el.split(';') }
      &.each_with_object({}) do |el, acc|
        acc[/\s+rel=\"(?<link>\w+)/.match(el.last)[:link]] =
          (/&page=(?<page>\d+)/.match(el.first)[:page])
      end
  rescue NoMethodError => e
    raise GithubResponseDecoratorError, "error parsing pagination links, e: #{e}"
  end

  def create_response_object(items, links)
    hsh = { items: items }.merge(links || {})
    OpenStruct.new(hsh)
  end
end
