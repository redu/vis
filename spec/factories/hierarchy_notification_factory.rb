FactoryGirl.define do
  factory :hierarchy_notification do |hierar|
    hierar.sequence(:user_id){ |n| n }
    hierar.type "tipo"
  end

  factory :hierarchy_notification_activity,
          :class => :hierarchy_notification do |hierar|
    hierar.sequence(:user_id){ |n| n }
    hierar.sequence(:status_id){ |p| p }
    hierar.type "activity"
  end

  factory :hierarchy_notification_help,
    :class => :hierarchy_notification do |hierar|
      hierar.sequence(:user_id){ |n| n }
      hierar.sequence(:status_id){ |p| p }
      hierar.type "help"
  end

  factory :hierarchy_notification_answered_help,
          :class => :hierarchy_notification do |hierar|
    hierar.sequence(:user_id){ |n| n }
    hierar.sequence(:status_id){ |p| p }
    hierar.sequence(:in_response_to_id){ |q| q }
    hierar.type "answered_help"
  end

  factory :hierarchy_notification_answered_activity,
    :class => :hierarchy_notification do |hierar|
      hierar.sequence(:user_id){ |n| n }
      hierar.sequence(:status_id){ |p| p }
      hierar.sequence(:in_response_to_id){ |q| q }
      hierar.type "answered_activity"
  end

  factory :hierarchy_notification_enrollment,
    :class => :hierarchy_notification do |hierar|
      hierar.sequence(:user_id){ |n| n }
      hierar.type "enrollment"
  end

  factory :hierarchy_notification_remove_enrollment,
    :class => :hierarchy_notification do |hierar|
      hierar.sequence(:user_id){ |n| n }
      hierar.type "remove_enrollment"
  end

  factory :hierarchy_notification_subject_finalized,
          :class => :hierarchy_notification do |hierar|
    hierar.sequence(:user_id){ |n| n }
    hierar.type "subject_finalized"
  end

  factory :hierarchy_notification_remove_subject_finalized,
          :class => :hierarchy_notification do |hierar|
    hierar.sequence(:user_id){ |n| n }
    hierar.type "remove_subject_finalized"
  end

  factory :hierarchy_notification_exercise_finalized,
          :class => :hierarchy_notification do |hierar|
    hierar.sequence(:user_id){ |n| n }
    hierar.type "exercise_finalized"
    hierar.sequence(:grade){ |a| a }
  end
end
