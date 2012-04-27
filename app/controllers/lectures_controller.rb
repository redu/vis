class LecturesController < ApplicationController

  def participation
    @participation = LectureParticipation.new(params[:lectures],
                                              params[:date_start],
                                              params[:date_end])
    @participation.extend(LectureParticipationRepresenter)

    respond_with(@participation)
  end
end
