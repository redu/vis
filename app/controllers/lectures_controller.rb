class LecturesController < ApplicationController

  def participation
    @participation = LectureParticipation.new(params[:lectures],
                                              params[:date_start],
                                              params[:date_end])
    @participation.extend(LectureParticipationRepresenter)

    respond_to do |format|
      format.json { render :json => @participation,
                    :callback => params[:callback] }
    end
  end
end
