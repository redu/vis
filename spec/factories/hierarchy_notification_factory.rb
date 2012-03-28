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

  factory :hierarchy_notification_answered_help,
          :class => :hierarchy_notification do |hierar|
    hierar.sequence(:user_id){ |n| n }
    hierar.sequence(:type){ "answered_help" }
  end

  factory :hierarchy_notification_enrollment,
          :class => :hierarchy_notification do |hierar|
    hierar.sequence(:user_id){ |n| n }
    hierar.sequence(:type){ "enrollment" }
  end

  factory :hierarchy_notification_subject_finalized,
          :class => :hierarchy_notification do |hierar|
    hierar.sequence(:user_id){ |n| n }
    hierar.sequence(:type){ "subject_finalized" }
  end
end
