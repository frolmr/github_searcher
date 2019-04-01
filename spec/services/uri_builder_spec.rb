# frozen_string_literal: true

require_relative '../../app/services/uri_builder'

RSpec.describe UriBuilder do
  subject { described_class.call(search_subject, keywords) }

  let(:basic_uri) { "https://api.github.com/search/" }

  context 'when search for repositories' do
    let(:search_subject) { 'repositories' }
    let(:keywords) { ['foo', 'bar', 'baz'] }

    let(:uri) { URI("#{basic_uri}repositories?q=foo+bar+baz&page=1") }

    it 'should return correct URI obj' do
      expect(subject).to eq uri
    end
  end

  context 'when search for users' do
    let(:search_subject) { 'users' }
    let(:keywords) { ['frol'] }

    let(:uri) { URI("#{basic_uri}users?q=frol&page=1") }

    it 'should return correct URI obj' do
      expect(subject).to eq uri
    end
  end
end
