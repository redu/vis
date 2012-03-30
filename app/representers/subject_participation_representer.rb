module SubjectParticipationRepresenter
  include Roar::Representer::JSON

  property :helps
  property :answered_helps
  property :subjects_finalized
  property :enrollments
end
