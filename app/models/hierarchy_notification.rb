class HierarchyNotification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id
  field :type
  field :lecture_id
  field :subject_id
  field :space_id
  field :course_id
  field :status_id
  field :statusable_id
  field :statusable_type
  field :in_response_to_id
  field :in_response_to_type

  validates_presence_of :user_id
  validates_presence_of :type

  scope :by_subject, lambda { |id| where(:subject_id => id) }
  scope :by_lecture, lambda { |id| any_in(:lecture_id => id) }
  scope :by_type, lambda { |kind| where(:type => kind) }
  scope :by_day, lambda { |day| where(:created_at.gte => day, :created_at.lt => day + 1)}
  scope :answered, lambda { |answers|
    any_in(:status_id => answers.distinct(:in_response_to_id)).where(
      :type => "help") }
end
