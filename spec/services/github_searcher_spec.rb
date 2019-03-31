# frozen_string_literal: true

require_relative '../../app/services/github_searcher'

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
end
