class UserSpaceParticipation
  attr_reader :users_space_participation

  def initialize(users_id, space_id, date_start, date_end)
    @users_id = users_id.collect{ |user_id| user_id.to_i }
    @space_id = space_id.to_i
    @date_start = date_start
    @date_end = date_end
  end

  def users_space_participation
    @users_id.collect do |user_id|
      { user_id => {
          :helps => helps(user_id),
          :activities => activities(user_id),
          :answered_helps => answered_helps(user_id),
          :answered_activities => answered_activities(user_id),
          :average_grade => average_grade(user_id)
        }
      }
    end
  end

  protected

  def helps(user_id)
    HierarchyNotification.by_type("help").by_user(user_id).
      by_space(@space_id).by_period(@date_start, @date_end).count
  end

  def activities(user_id)
    HierarchyNotification.by_type("activity").by_user(user_id).
      by_space(@space_id).by_period(@date_start, @date_end).count
  end

  def answered_helps(user_id)
    HierarchyNotification.by_type("answered_help").by_user(user_id).
      by_space(@space_id).by_period(@date_start, @date_end).count
  end

  def answered_activities(user_id)
    HierarchyNotification.by_type("answered_activity").by_user(user_id).
      by_space(@space_id).by_period(@date_start, @date_end).count
  end

  def average_grade(user_id)
    HierarchyNotification.by_space(@space_id).
      by_period(@date_start, @date_end).average_grade(user_id)
  end
end
