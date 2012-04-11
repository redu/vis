class SubjectParticipation
  attr_reader :helps, :answered_helps, :helps_answered,
              :helps_not_answered, :subjects_finalized,
              :enrollments, :ranges, :markers, :measures

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

  def helps_answered
    help = self.notifications.by_type("help")
    ans = self.notifications.by_type("answered_help")
    help.answered(ans).count
  end

  def helps_not_answered
    self.helps - self.helps_answered
  end

  def subjects_finalized
    self.notifications.by_type("subject_finalized").count
  end

  def enrollments
    self.notifications.by_type("enrollment").count
  end

  # Método para construção do d3 bullet charts
  def ranges
    [self.enrollments]
  end

  def measures
    [self.subjects_finalized]
  end

  def markers
    self.measures
  end
end
