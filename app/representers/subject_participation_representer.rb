module SubjectParticipationRepresenter
  include Roar::Representer::JSON

  property :helps
  property :helps_answered
  property :helps_not_answered
  property :answered_helps
  property :subjects_finalized
  property :enrollments
end
