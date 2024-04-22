FactoryBot.define do
  factory :conversation_user do
    user_id { 0 }
    conversation_id { 0 }

    trait :with_ids do
      conversation_id { |attrs| attrs[:conversation_id]}
      user_id {|attrs| attrs[:user_id]}
    end
  end
end
