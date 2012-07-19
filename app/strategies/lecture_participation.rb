class LectureParticipation
  attr_reader :helps, :answered_helps, :answered_activities,
              :activities, :visualizations, :helps_by_day,
              :answered_helps_by_day, :answered_activities_by_day,
              :activities_by_day, :visualizations_by_day, :days

  attr_accessor :start, :end

  # lecture_id = [id's] para um ou mais Lectures
  # Para consultas por dia: start_time, end_time
  def initialize(lecture_id, date_start, date_end)
    @id = lecture_id.collect{ |id| id.to_i }
    @end = date_end.to_date
    @start = date_start.to_date
  end

  def notifications
    HierarchyNotification.by_lecture(@id)
  end

  def helps
    notifications.status_not_removed("help").count
  end

  def activities
    notifications.status_not_removed("activity").count
  end

  def answered_activities
    notifications.status_not_removed("answered_activity").count
  end

  def answered_helps
    notifications.status_not_removed("answered_help").count
  end

  # Filtrados por dia
  def helps_by_day
    cond = notifications.status_not_removed("help").selector

    help = HierarchyNotification.daily(cond)

    hel = Hash.new
    help.map { |h| hel[h["date"]] = { "helps" => h["count"] }}

    order(hel, "helps")
  end

  def activities_by_day
    cond = notifications.status_not_removed("activity").selector

    activity = HierarchyNotification.daily(cond)
    acti = Hash.new
    activity.map { |h| acti[h["date"]] =
                   { "activities" => h["count"] }}

    order(acti, "activities")
  end

  def answered_helps_by_day
    cond = notifications.status_not_removed("answered_help").selector

    ans_hel = HierarchyNotification.daily(cond)

    ans = Hash.new
    ans_hel.map { |h| ans[h["date"]] =
                  { "answered_helps" => h["count"] }}

    order(ans, "answered_helps")
  end

  def answered_activities_by_day
    cond = notifications.status_not_removed("answered_activity").selector

    ans_activity = HierarchyNotification.daily(cond)

    ans = Hash.new
    ans_activity.map { |h| ans[h["date"]] =
                       { "answered_activities" => h["count"] }}

    order(ans, "answered_activities")
  end

  def order(hash, type)
    start = self.start
    daily = []

    (0..(self.end - self.start)).each do
      day = start.strftime("%Y-%-m-%-d")
      res =  hash[day] ? hash[day][type] : 0

      daily << res
      start += 1
    end

    daily
  end

  def days
    start = self.start
    daily = []

    (0..(self.end - self.start)).each do
      daily << start.strftime("%-d/%m")
      start += 1
    end

    daily
  end
end
