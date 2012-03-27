Factory.define(:hierarchy_notification) do |hierar|
  hierar.sequence(:user_id){ |n| n }
  hierar.sequence(:type){ "help" }
end
