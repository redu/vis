class HierarchyNotificationsController < ApplicationController
  respond_to :json
  before_filter :authentication

  def create
    @hierarchy = HierarchyNotification.new(params[:hierarchy_notification])

    respond_to do |format|
      if @hierarchy.save
        format.json { render :json => @hierarchy.to_json, :status => 201 }
      else
        format.json { render :json => @hierarchy.errors.to_json, :status => 400 }
      end
    end
  end

  protected

  def authentication
    authenticate_or_request_with_http_basic do |username, password|
      {:username => username, :password => password} ==
        Vis::Application.config.user_data_authentication
    end
  end
end
