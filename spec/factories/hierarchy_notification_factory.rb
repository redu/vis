FactoryGirl.define do
  factory :hierarchy_notification do |hierar|
    hierar.sequence(:user_id){ |n| n }
    hierar.sequence(:type){ "tipo" }
  end

  factory :hierarchy_notification_help,
          :class => :hierarchy_notification do |hierar|
    hierar.sequence(:user_id){ |n| n }
    hierar.sequence(:type){ "help" }
  end
end
