class HierarchyNotification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, :type => Integer
  field :type
  field :lecture_id, :type => Integer
  field :subject_id, :type => Integer
  field :space_id, :type => Integer
  field :course_id, :type => Integer
  field :status_id, :type => Integer
  field :statusable_id, :type => Integer
  field :statusable_type
  field :in_response_to_id, :type => Integer
  field :in_response_to_type
  field :grade, :type => Float

  validates_presence_of :user_id
  validates_presence_of :type

  scope :by_subject, lambda { |id| where(:subject_id => id) }
  scope :by_lecture, lambda { |id| any_in(:lecture_id => id) }
  scope :by_type, lambda { |kind| where(:type => kind) }
  scope :by_day, lambda { |day| where(:created_at.gte => day, :created_at.lt => day + 1)}
  scope :answered, lambda { |answers|
    any_in(:status_id => answers.distinct(:in_response_to_id)).where(
      :type => "help") }

  def self.notification_exists?(hierar)
    conditions = {
      :user_id => hierar.user_id,
      :status_id => hierar.status_id,
      :statusable_id => hierar.statusable_id,
      :statusable_type => hierar.statusable_type,
      :in_response_to_id => hierar.in_response_to_id,
      :in_response_to_type => hierar.in_response_to_type,
      :lecture_id => hierar.lecture_id,
      :subject_id => hierar.subject_id,
      :space_id => hierar.space_id,
      :course_id => hierar.course_id,
      :type => hierar.type,
      :created_at => hierar.created_at,
      :updated_at => hierar.updated_at
    }

    self.exists?(:conditions => conditions)
  end

  class << self
    def grade_average(id)
      where(:user_id => id).avg(:grade)
    end
  end
end
