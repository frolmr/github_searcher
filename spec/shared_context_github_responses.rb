# frozen_string_literal: true

RSpec.shared_context 'github respositories search response' do
  let(:repositories) do
    {
      items:
      [
        {
          html_url: "https://github.com/opencharles/charles-rest",
          description: "Github chatbot and web-content indexer/searcher"
        },
        {
          html_url: "https://github.com/PaulHalliday/Learn-Ionic-3-From-Scratch-Github-Searcher",
          description: "Used as part of the \"Learn Ionic 3 From Scratch\""
        }
      ]
    }
  end
end

RSpec.shared_context 'github users search response' do
  let(:users) do
    {
      id: 1
    }
  end
end
