class LectureParticipation
  attr_reader :helps, :answered_helps, :answered_activities,
              :activities, :visualizations

  def initialize(lecture_id)
    @id = lecture_id
  end

  def notifications
    HierarchyNotification.by_lecture(@id)
  end

  def helps
    notifications.by_type("help")
  end

  def activities
    notifications.by_type("activity")
  end

  def answered_activities
    notifications.by_type("answered_activity")
  end

  def answered_helps
    notifications.by_type("answered_help")
  end
end
