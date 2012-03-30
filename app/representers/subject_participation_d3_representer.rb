module SubjectParticipationD3Representer
  include Roar::Representer::JSON

  # Esse Representer tem que ser construído seguindo o formato:
  # SubjectParticipationD3Representer.from_json('{"ranges":[20,25]}')
  # Onde o primeiro número é subjects_finalized e o segundo enrollments

  property :ranges
end
