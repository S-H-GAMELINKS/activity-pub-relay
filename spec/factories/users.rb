FactoryBot.define do
  factory :user do
    email_address { "activity-pub-relay@example.com" }
    password { "activity-pub-relay-pass" }
  end
end
