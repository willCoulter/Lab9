FactoryBot.define do
  factory :comment do
    user
    article
    message 'TestBoys'
  end
end
