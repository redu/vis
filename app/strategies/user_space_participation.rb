class UserSpaceParticipation
  attr_reader :space_id, :response

  def initialize(users_id, space_id, date_start, date_end)
    @users_id = users_id
    @space_id = space_id.to_i
    @date_start = date_start
    @date_end = date_end

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
    helps = HierarchyNotification.by_space(@space_id).
      by_period(@date_start, @date_end).status_not_removed("help").
      only(:user_id).aggregate

    @helps = Hash.new
    helps.map { |h| @helps[h["user_id"].to_i] = {"helps" => h["count"].to_i }}

    @helps
  end

  def activities
    acti = HierarchyNotification.by_space(@space_id).
      by_period(@date_start, @date_end).status_not_removed("activity").
      only(:user_id).aggregate

    @activities = Hash.new
    acti.map { |h| @activities[h["user_id"].to_i] =
               { "activities" => h["count"].to_i }}

    @activities
  end

  def answered_helps
    ans_helps = HierarchyNotification.by_space(@space_id).
      by_period(@date_start, @date_end).
      status_not_removed("answered_help").only(:user_id).aggregate

    @answered_helps = Hash.new
    ans_helps.map { |h| @answered_helps[h["user_id"].to_i] =
                    { "answered_helps" => h["count"].to_i }}

    @answered_helps
  end

  def answered_activities
    ans_acti = HierarchyNotification.by_space(@space_id).
      by_period(@date_start, @date_end).
      status_not_removed("answered_activity").only(:user_id).aggregate

    @answered_activities = Hash.new
    ans_acti.map { |h| @answered_activities[h["user_id"].to_i] =
                   { "answered_activities" => h["count"].to_i }}

    @answered_activities
  end

  def average_grade
    cond = HierarchyNotification.by_space(@space_id).
      by_period(@date_start, @date_end).where(:type => "exercise_finalized").
      selector

    avg = HierarchyNotification.average_grade(cond)

    @average_grade = Hash.new
    avg.map { |h| @average_grade[h["user_id"].to_i] =
              { "average_grade" => h["avg"] }}

    @average_grade
  end
end
