Factory.define :status do |s|
  s.sequence(:status_id) {|n| n}
  s.sequence(:user_id) {|n| n+1}
  s.sequence(:statusable_id) {|n| n+2}
  s.sequence(:statusable_type) { "Lecture" }
  s.sequence(:in_response_to_id) { |n| n+3 }
  s.sequence(:in_response_to_type) { "Lecture" }
  u.sequence(:type) { "Enrollment" }
end
