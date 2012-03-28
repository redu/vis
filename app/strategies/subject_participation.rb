class SubjectParticipation
  attr_reader :helps, :answered_helps

  def initialize (subject_id)
    @id = subject_id
  end

  def notifications
    HierarchyNotification.by_subject(@id)
  end

  def helps
    self.notifications.by_type("help").count
  end

  def answered_helps
    self.notifications.by_type("answered_help").count
  end
end
