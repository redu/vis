module UserSpaceParticipationRepresenter
  include Roar::Representer::JSON

  property :user_id
  property :space_id
  property :data
end
