# frozen_string_literal: true

require_relative '../../spec_helper'
require_relative '../../../app/services/decorators/github_response_decorator'
require_relative '../../shared_context_github_responses'

RSpec.describe GithubResponseDecorator do
  subject { described_class.call(response) }

  let(:uri) { URI('https://api.github.com/search/repositories?q=github_searcher') }
  let(:response) { Net::HTTP.get_response(uri) }

  context 'error cases' do
    context 'bad response body format' do
      before do
        stub_request(:get, uri).
          to_return(status: 200, body: "sad_cat")
      end

      it 'raises GithubResponseDecoratorError' do
        expect { subject }.to raise_error(GithubResponseDecoratorError, /response parsing error:/)
      end
    end
  end

  context 'success cases' do
    include_context 'github respositories search response'

    context 'when no pagination needed' do
      before do
        stub_request(:get, uri).
          to_return(status: 200, body: repositories.to_json.to_s, headers: { Link: nil })
      end

      it 'returns openstruct' do
        expect(subject).to be_a(OpenStruct)
      end

      it 'returns correct response' do
        expect(subject).to eq(OpenStruct.new(JSON.parse(repositories.to_json)))
      end
    end

    context 'when paginatino needed' do
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

      let(:decorated) do
        OpenStruct.new(JSON.parse(repositories.merge(pages).to_json))
      end

      it 'returns correct response' do
        expect(subject).to eq decorated
      end
    end
  end
end
