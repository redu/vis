class UserSpacesController < ApplicationController
  def participation
    participation = params[:users_id].collect do |user_id|
      UserSpaceParticipation.new(
        user_id,
        params[:space_id],
        params[:date_start],
        params[:date_end]).extend(UserSpaceParticipationRepresenter)
    end

    respond_to do |format|
      format.json { render :json => participation,
                    :callback => params[:callback] }
    end
  end
end
