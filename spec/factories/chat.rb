FactoryBot.define do
  factory :chat do
    sender_id { 0 }
    conversation_id { 0 }
    message {""}

    trait :with_attrs do
      conversation_id { |attrs| attrs[:conversation_id]}
      sender_id {|attrs| attrs[:user_id]}
      message {|attrs| attrs[:message]}
    end
  end
end