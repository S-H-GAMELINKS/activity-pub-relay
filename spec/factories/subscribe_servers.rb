FactoryBot.define do
  factory :subscribe_server do
    domain { "www.example.com" }
    inbox_url { "https://www.example.com/inbox" }
    delivery_suspend { false }
    domain_block { false }
  end
end
