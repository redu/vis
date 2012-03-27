class SubjectParticipation
  attr_reader :helps, :answered_helps

  def initialize (subject_id)
    @id = subject_id
  end

  def notifications
    @notifications = HierarchyNotification.by_subject(@id)
  end

  def helps_notifications
    @notifications.by_type("help")
  end

  def answers_helps_notifications
    @notifications.by_type("answered_help")
  end

  def generate!
    self.notifications

    @helps = self.helps_notifications.count
    @answered_helps = self.answers_helps_notifications.count
  end
end
