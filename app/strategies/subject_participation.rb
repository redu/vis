class SubjectParticipation
  attr_reader :helps, :answered_helps,
              :subjects_finalized, :enrollments, :ranges

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

  def subjects_finalized
    self.notifications.by_type("subject_finalized").count
  end

  def enrollments
    self.notifications.by_type("enrollment").count
  end

  # Método para construção do d3 bullet charts
  def ranges
    [self.subjects_finalized, self.enrollments]
  end
end
