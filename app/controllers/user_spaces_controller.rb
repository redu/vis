class UserSpacesController < ApplicationController
  def participation
    participation = UserSpaceParticipation.new(
      params[:users_id],
      params[:space_id],
      params[:date_start],
      params[:date_end]).response

      respond_to do |format|
        format.json { render :json => participation,
                      :callback => params[:callback] }
      end
  end
end
