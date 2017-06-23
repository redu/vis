module LectureParticipationRepresenter
  include Roar::JSON

  property :helps
  property :activities
  property :answered_helps
  property :answered_activities
  property :visualizations

  property :helps_by_day
  property :activities_by_day
  property :answered_helps_by_day
  property :answered_activities_by_day
  property :visualizations_by_day

  property :days
end
