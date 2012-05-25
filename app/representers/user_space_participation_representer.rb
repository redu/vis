module UserSpaceParticipationRepresenter
  include Roar::Representer::JSON

  collection :users_space_participation, :from => :users_participation
end
