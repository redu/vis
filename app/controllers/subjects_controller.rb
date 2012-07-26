class SubjectsController < ApplicationController
  def activities
    activity = SubjectParticipation.new(params[:subject_id])
    activity.extend(SubjectParticipationRepresenter)

    respond_to do |format|
      format.json { render :json => activity,
                    :callback => params[:callback] }
    end
  end

  def activities_d3
    d3 = SubjectParticipation.new(params[:subject_id])
    d3.extend(SubjectParticipationD3Representer)

    respond_to do |format|
      format.json { render :json => [d3],
                    :callback => params[:callback] }
    end
  end

end
