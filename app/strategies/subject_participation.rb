class SubjectParticipation
  attr_reader :helps, :answered_helps, :helps_answered,
              :helps_not_answered, :subjects_finalized, :enrollments

  def initialize(subject_id)
    @id = subject_id.map { |id| id.to_i }
  end

  def notifications
    HierarchyNotification.by_subject(@id)
  end

  def helps
    self.notifications.status_not_removed("help").grouped(:subject_id, "helps")
  end

  def answered_helps
    self.notifications.status_not_removed("answered_help").
      grouped(:subject_id, "answered_helps")
  end

  def helps_answered
    help = self.notifications.status_not_removed("help")
    ans = self.notifications.status_not_removed("answered_help")
    help.answered(ans).grouped(:subject_id, "helps_answered")
  end

  def helps_not_answered
    self.helps.merge(self.helps_answered) {
      |key, old, new| { "helps_not_answered" =>
                        old["helps"] - new["helps_answered"] }}
  end

  def subjects_finalized
    removed = self.removed_subjects_finalized
    total = self.notifications.by_type("subject_finalized").
      grouped(:subject_id, "subjects_finalized")

    total.merge(removed) { |key, old, new|
      { "subjects_finalized" =>
        old["subjects_finalized"] - new["removed_subjects_finalized"] }}
  end

  def enrollments
    removed = self.removed_enrollments
    total = self.notifications.by_type("enrollment").
      grouped(:subject_id, "enrollments")

    total.merge(removed) { |key, old, new|
      { "enrollments" =>
        old["enrollments"] - new["removed_enrollments"] }}
  end

  # Contagem de enrollments deve levar em conta
  # as matrículas desfeitas nos módulos
  def removed_enrollments
    self.notifications.by_type("remove_enrollment").
      grouped(:subject_id, "removed_enrollments")
  end

  # Contagem de subjects finalized deve levar em conta
  # os subjects finalizeds desfeitos nos módulos
  def removed_subjects_finalized
    self.notifications.by_type("remove_subject_finalized").
      grouped(:subject_id, "removed_subjects_finalized")
  end
end
