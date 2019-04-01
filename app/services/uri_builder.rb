# frozen_string_literal: true

class UriBuilder < BaseService
  BASIC_URI = 'https://api.github.com/search/'

  def initialize(search_subject, keywords, page_number = '1')
    @search_subject = search_subject
    @keywords = keywords
    @page_number = page_number
  end

  def call
    uri_string =
      BASIC_URI +
      @search_subject +
      '?q=' +
      @keywords.join('+') +
      '&page=' +
      @page_number

    URI(uri_string)
  end
end
