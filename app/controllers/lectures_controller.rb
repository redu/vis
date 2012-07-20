class LecturesController < ApplicationController
  def participation
    part = LectureParticipation.new(params[:lectures],
                                    params[:date_start],
                                    params[:date_end])
    part.extend(LectureParticipationRepresenter)

    respond_to do |format|
      format.json { render :json => part,
                    :callback => params[:callback] }
    end
  end
end
