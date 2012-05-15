class SubjectsController < ApplicationController
  before_filter :authentication

  def activities
    @activity = SubjectParticipation.new(params[:subject_id])
    @activity.extend(SubjectParticipationRepresenter)

    respond_to do |format|
      format.json { render :json => @activity,
                    :callback => params[:callback] }
    end
  end

  def activities_d3
    @d3 = SubjectParticipation.new(params[:subject_id])
    @d3.extend(SubjectParticipationD3Representer)

    respond_to do |format|
      format.json { render :json => [@d3],
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
