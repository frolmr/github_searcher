# frozen_string_literal: true

require_relative '../../app/services/github_searcher'
require_relative '../shared_context_github_responses'

RSpec.describe GithubSearcher do
  subject { described_class.call(params) }

  context 'when invalid params' do
    let(:params) do
      { foo: 'bar', fizz: 'buzz' }
    end

    it 'should return validation error' do
      expect { subject }.to raise_error(GithubSearcherError,
                                        '{:params=>{:search_subject=>["is missing"], :keywords=>["is missing"]}}')
    end
  end

  context 'when unknown search subject' do
    let(:params) do
      {
        keywords: 'foo bar baz',
        search_subject: 'commits'
      }
    end

    it 'should return validation error' do
      expect { subject }.to raise_error(GithubSearcherError,
                                        '{:params=>{:search_subject=>["is in invalid format"]}}')
    end
  end

  context 'when correct input' do
    include_context 'github respositories search response'

    let(:uri) { URI('https://api.github.com/search/repositories?q=guessing_game&page=1') }

    before do
      stub_request(:get, uri).
        to_return(status: 200,
                  body: repositories.to_json.to_s,
                  headers: { Link: "&page=2; rel=\"next\", &page=11; rel=\"last\"" })
    end

    let(:pages) do
      {
        next: '2',
        last: '11'
      }
    end

    let(:params) do
      {
        keywords: 'guessing_game',
        search_subject: 'repositories'
      }
    end

    let(:decorated) do
      OpenStruct.new(JSON.parse(repositories.merge(pages).to_json))
    end

    it 'returns OpenStruct' do
      expect(subject).to be_a(OpenStruct)
    end

    it 'returns correct response' do
      expect(subject).to eq decorated
    end
  end
end
