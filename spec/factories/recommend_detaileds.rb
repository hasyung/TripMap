# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :recommend_detailed do
    recommend_record_id 1
    name "MyString"
    order 1
  end
end
