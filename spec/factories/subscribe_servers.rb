FactoryBot.define do
  factory :subscribe_server do
    domain { "www.example.com" }
    inbox_url { "https://www.example.com/inbox" }
  end
end
