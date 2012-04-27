class LectureParticipation
  attr_reader :helps, :answered_helps, :answered_activities,
              :activities, :visualizations, :helps_by_day,
              :answered_helps_by_day, :answered_activities_by_day,
              :activities_by_day, :visualizations_by_day, :days

  attr_accessor :start, :end

  # lecture_id = [id's] para um ou mais Lectures
  # Para consultas por dia: start_time, end_time
  def initialize(lecture_id)
    @id = lecture_id
    @end = Date.today
    @start = @end - 9
  end

  def initialize_params(lecture_id, date_start, date_end)
    @id = lecture_id.collect{ |id| id.to_i }
    @end = date_end.to_date
    @start = date_start.to_date
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

  def helps_by_day
    self.daily("help")
  end

  def activities_by_day
    self.daily("activity")
  end

  def answered_activities_by_day
    self.daily("answered_activity")
  end

  def answered_helps_by_day
    self.daily("answered_help")
  end

  def daily(type)
    start = self.start
    daily = []

    (0..(self.end - self.start)).each do
      daily << notifications.by_type(type).by_day(start).count
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
