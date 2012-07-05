class UserSpaceParticipation
  attr_reader :user_id, :space_id, :data

  def initialize(user_id, space_id, date_start, date_end)
    @user_id = user_id.to_i
    @space_id = space_id.to_i
    @date_start = date_start
    @date_end = date_end
  end

  def data
    { :helps => helps(user_id),
      :activities => activities(user_id),
      :answered_helps => answered_helps(user_id),
      :answered_activities => answered_activities(user_id),
      :average_grade => average_grade(user_id) }
  end

  protected

  def helps(user_id)
    HierarchyNotification.by_user(user_id).by_space(@space_id).
      by_period(@date_start, @date_end).status_not_removed("help").count
  end

  def activities(user_id)
    HierarchyNotification.by_user(user_id).by_space(@space_id).
      by_period(@date_start, @date_end).
      status_not_removed("activity").count
  end

  def answered_helps(user_id)
    HierarchyNotification.by_user(user_id).by_space(@space_id).
      by_period(@date_start, @date_end).
      status_not_removed("answered_help").count
  end

  def answered_activities(user_id)
    HierarchyNotification.by_user(user_id).by_space(@space_id).
      by_period(@date_start, @date_end).
      status_not_removed("answered_activity").count
  end

  def average_grade(user_id)
    HierarchyNotification.by_space(@space_id).
      by_period(@date_start, @date_end).average_grade(user_id)
  end
end
