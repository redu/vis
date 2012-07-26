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

  scope :by_space, lambda { |id| where(:space_id => id) }
  scope :by_subject, lambda { |id| where(:subject_id => id) }
  scope :by_lecture, lambda { |id| any_in(:lecture_id => id) }
  scope :by_type, lambda { |kind| where(:type => kind) }
  scope :answered, lambda { |answers|
    any_in(:status_id => answers.distinct(:in_response_to_id)).where(
      :type => "help") }
  scope :by_period, lambda { |date1, date2| where(
    :created_at => (date1..date2)) }

  # Coleta Statuses que não foram destruídos
  scope :status_not_removed, lambda { |type| where(
    :type => type).where(
      :status_id.nin => where(
        :type => "remove_#{type}").only(:status_id).map(&:status_id)) }

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

  def self.average_grade(cond = { :type => "exercise_finalized" })
    # Usa o collection para inserir a opção finalize no group
    collection.group({
      :key => :user_id,
      :cond => cond,
      :reduce => "function(d, o) { o.sum += d.grade; o.count++; }",
      :initial => { :sum => 0, :count => 0 },
      :finalize => "function(out) { out.avg = out.sum/out.count }" })
  end

  def self.daily(cond = {})
    # Usa o collection para inserir a opção keyf visando agrupar apenas
    # por dia e não por Timestamp(:created_at)
    collection.group({
      :keyf => "function(doc) { d = new Date(doc.created_at);
                  return { date: d.getFullYear() + '-' + (d.getMonth() + 1) +
                            '-' + d.getDate() }; }",
      :cond => cond,
      :reduce => "function(d, o) { o.count++; }",
      :initial => { :count => 0 },
    })
  end
end
