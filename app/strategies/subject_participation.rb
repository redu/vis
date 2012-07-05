class SubjectParticipation
  attr_reader :helps, :answered_helps, :helps_answered,
              :helps_not_answered, :subjects_finalized,
              :enrollments, :ranges, :markers, :measures

  def initialize(subject_id)
    @id = subject_id
  end

  def notifications
    HierarchyNotification.by_subject(@id)
  end

  def helps
    self.notifications.status_not_removed("help").count
  end

  def answered_helps
    self.notifications.status_not_removed("answered_help").count
  end

  def helps_answered
    help = self.notifications.status_not_removed("help")
    ans = self.notifications.status_not_removed("answered_help")
    help.answered(ans).count
  end

  def helps_not_answered
    self.helps - self.helps_answered
  end

  def subjects_finalized
    removed = self.removed_subjects_finalized
    self.notifications.by_type("subject_finalized").count - removed
  end

  def enrollments
    self.notifications.by_type("enrollment").count - self.removed_enrollments
  end

  # Contagem de enrollments deve levar em conta
  # as matrículas desfeitas nos módulos
  def removed_enrollments
    self.notifications.by_type("remove_enrollment").count
  end

  # Contagem de subjects finalized deve levar em conta
  # os subjects finalizeds desfeitos nos módulos
  def removed_subjects_finalized
    self.notifications.by_type("remove_subject_finalized").count
  end

  # Método para construção do d3 bullet chart
  def ranges
    [self.enrollments]
  end

  def measures
    [self.subjects_finalized]
  end

  def markers
    self.ranges
  end
end
