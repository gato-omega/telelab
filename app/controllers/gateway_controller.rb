class GatewayController < ApplicationController

  layout false

  rescue_from CanCan::AccessDenied do |exception|
    not_authorized
  end

  before_filter :authenticate_for_gateway
  before_filter :get_irc_gateway

  def index
    puts params
    gateway_action = params.delete :gateway_action
    case gateway_action
      when 'status'
        render :status => 200
      when 'create_vlan'
        params
        render :status => 200
      when 'send_irc'
        channel, message = params[:channel], params[:message]
        @irc_gateway.send_irc channel, message
        render :status => 200

    end
  end

  def authenticate_for_gateway
    authorize! :communicate_with_gateway, :gateway
  end

  def not_authorized
    render :status => 403
  end

  private
  def get_irc_gateway
    @irc_gateway = IRCGateway.instance
  end
end
