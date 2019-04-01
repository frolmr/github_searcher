# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../app/services/github_requester'
require_relative '../shared_context_github_responses'

RSpec.describe GithubRequester do
  subject { described_class.call(uri) }

  let(:uri) { URI('https://api.github.com/search/repositories?q=github_searcher') }

  context 'error cases' do
    context 'when Net::HTTP raises error' do
      before do
        allow(Net::HTTP).to receive(:get_response) do
          raise Net::HTTPHeaderSyntaxError
        end
      end

      it 'raises GithubRequesterError' do
        expect { subject }.to raise_error(GithubRequesterError)
      end
    end

    context 'when response code is not 200' do
      before do
        stub_request(:get, uri).
          to_return(status: 500)
      end

      it 'raises GithubRequesterError' do
        expect { subject }.to raise_error(GithubRequesterError, 'bad response code from GitHub')
      end
    end
  end

  context 'positive cases' do
    context 'repositories searching' do
      include_context 'github respositories search response'

      before do
        stub_request(:get, uri).
          to_return(status: 200, body: repositories.to_s)
      end

      it 'returns response' do
        expect(subject.body).to eq repositories.to_s
      end
    end

    context 'users searching' do

      let(:uri) { URI('https://api.github.com/search/users?q=frol') }

      include_context 'github users search response'

      before do
        stub_request(:get, uri).
          to_return(status: 200, body: users.to_s)
      end

      it 'returns response' do
        expect(subject.body).to eq users.to_s
      end
    end
  end
end
