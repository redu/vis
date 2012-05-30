class LecturesController < ApplicationController
  before_filter :authentication

  def participation
    participation = LectureParticipation.new(params[:lectures],
                                              params[:date_start],
                                              params[:date_end])
    participation.extend(LectureParticipationRepresenter)

    respond_to do |format|
      format.json { render :json => participation,
                    :callback => params[:callback] }
    end
  end

  protected

  def authentication
    authenticate_or_request_with_http_basic do |username, password|
      {:username => username, :password => password} ==
        Vis::Application.config.api_data_authentication
    end
  end
end
