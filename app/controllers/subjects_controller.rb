class SubjectsController < ApplicationController
  def activities
    activity = SubjectParticipation.new(params[:subjects])

    respond_to do |format|
      format.json { render :json => activity,
                    :callback => params[:callback] }
    end
  end
end
