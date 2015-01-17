RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

FactoryGirl.define do
  factory :user do
    email "user@xyz.com"
    password  "abc12345"
    admin false
  end

  factory :admin, class: User do
    email "admin@xyz.com"
    password  "aaabbbcc"
    admin      true
  end
end