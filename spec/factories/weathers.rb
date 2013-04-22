# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :weather do
    tmp_current "MyString"
    tmp_today "MyString"
    tmp_desc "MyString"
    tmp_wind "MyString"
    tmp_pic_from "MyString"
    tmp_pic_to "MyString"
    tmp_humidity "MyString"
  end
end
