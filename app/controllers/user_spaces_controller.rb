class UserSpacesController < ApplicationController
  def participation
    participation = params[:users_id].collect do |user_id|
      UserSpaceParticipation.new(
        user_id,
        params[:space_id],
        params[:date_start],
        params[:date_end]).extend(UserSpaceParticipationRepresenter)
    end

    respond_with participation
  end
end
