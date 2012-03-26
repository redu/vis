class HierarchyNotification
  include Mongoid::Document
  field :user_id
  field :status_id
  field :lecture_id
  field :subject_id
  field :space_id
  field :course_id
  field :statusable_id
  field :statusable_type
  field :in_response_to_id
  field :in_response_to_type
  field :type

  validates_presence_of :user_id
  validates_presence_of :type
end
