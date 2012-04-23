FactoryGirl.define do
  factory :hierarchy_notification do |hierar|
    hierar.sequence(:user_id){ |n| n }
    hierar.sequence(:type){ "tipo" }
  end

  factory :hierarchy_notification_activity,
          :class => :hierarchy_notification do |hierar|
    hierar.sequence(:user_id){ |n| n }
    hierar.sequence(:status_id){ |p| p }
    hierar.sequence(:type){ "activity" }
  end

  factory :hierarchy_notification_help,
    :class => :hierarchy_notification do |hierar|
      hierar.sequence(:user_id){ |n| n }
      hierar.sequence(:status_id){ |p| p }
      hierar.sequence(:type){ "help" }
  end

  factory :hierarchy_notification_answered_help,
          :class => :hierarchy_notification do |hierar|
    hierar.sequence(:user_id){ |n| n }
    hierar.sequence(:status_id){ |p| p }
    hierar.sequence(:in_response_to_id){ |q| q }
    hierar.sequence(:type){ "answered_help" }
  end

  factory :hierarchy_notification_answered_activity,
    :class => :hierarchy_notification do |hierar|
      hierar.sequence(:user_id){ |n| n }
      hierar.sequence(:status_id){ |p| p }
      hierar.sequence(:in_response_to_id){ |q| q }
      hierar.sequence(:type){ "answered_activity" }
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
