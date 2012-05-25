class UserSpacesController < ApplicationController
  def participation
    participation = UserSpaceParticipation.new(params[:users_id],
                                               params[:space_id],
                                               params[:date_start],
                                               params[:date_end])
    participation.extend(UserSpaceParticipationRepresenter)

    respond_with participation
  end
end
