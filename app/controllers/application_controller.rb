class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :json

  after_filter :set_access_control_headers

  private
  # Este método no rails permite o compartilhamento dos recursos
  # entre domínios distintos
  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, X-CSRF-Token'
  end
end
