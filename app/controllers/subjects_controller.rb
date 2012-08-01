class SubjectsController < ApplicationController
  def activities
    activity = SubjectParticipation.new(params[:subject_id])
    activity.extend(SubjectParticipationRepresenter)

    respond_to do |format|
      format.json { render :json => activity,
                    :callback => params[:callback] }
    end
  end
end
