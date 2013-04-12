class UserSpaceParticipation
  attr_reader :space_id, :response

  def initialize(space_id, date_start, date_end)
    @space_id = space_id.to_i
    @users_id = space_users
    @date_start = date_start.to_date
    @date_end = date_end.to_date

    self.generate!
  end

  def generate!
    self.helps
    self.activities
    self.answered_helps
    self.answered_activities
    self.average_grade

    @response = @users_id.collect do |user|
      { :user_id => user.to_i,
        :space_id => space_id,
        :data => data(user.to_i) }
    end
  end

  def data(id)
    { :helps => @helps[id] ? @helps[id]["helps"] : 0,
      :activities => @activities[id] ? @activities[id]["activities"] : 0,
      :answered_helps => @answered_helps[id] ?
                         @answered_helps[id]["answered_helps"] : 0,
      :answered_activities => @answered_activities[id] ?
                              @answered_activities[id]["answered_activities"] :
                              0,
      :average_grade => @average_grade[id] ?
                        @average_grade[id]["average_grade"] : -1 }
  end

  protected

  def helps
    @helps = build_hash("help", "helps")
  end

  def activities
    @activities = build_hash("activity", "activities")
  end

  def answered_helps
    @answered_helps = build_hash("answered_help", "answered_helps")
  end

  def answered_activities
    @answered_activities = build_hash("answered_activity",
                                      "answered_activities")
  end

  def build_hash(type, key)
    status =  HierarchyNotification.by_space(@space_id).
      by_period(@date_start, @date_end).
      status_not_removed(type).grouped(:user_id, key)
  end

  def average_grade
    cond = HierarchyNotification.by_space(@space_id).
      by_period(@date_start, @date_end).exercise_finalized_not_removed.
      selector

    avg = HierarchyNotification.average_grade(cond)

    @average_grade = Hash.new
    avg.map { |h| @average_grade[h["user_id"].to_i] =
              { "average_grade" => h["avg"] }}

    @average_grade
  end

  def space_users
    removed = HierarchyNotification.by_space(@space_id).
      by_type("remove_enrollment").grouped(:user_id, "remove_enrollment")

    total = HierarchyNotification.by_space(@space_id).
      by_type("enrollment").grouped(:user_id, "enrollment")

    results = total.merge(removed) { |k, old, new|
      { "enrollment" => old["enrollment"] - (new["remove_enrollment"] ?
                                             new["remove_enrollment"] : 0) }}

    results.delete_if { |key, value| value["enrollment"] < 1.0 }
    results.keys
  end
end
