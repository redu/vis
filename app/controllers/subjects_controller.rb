class SubjectsController < ApplicationController

  def activities
    @activity = SubjectParticipation.new(params[:subject_id].to_i)
    @activity.extend(SubjectParticipationRepresenter)

    respond_with(@activity)
  end

  def activities_d3
    @d3 = SubjectParticipation.new(params[:subject_id].to_i)
    @d3.extend(SubjectParticipationD3Representer)

    respond_with([@d3])
  end
end
