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

      when 'send_irc'
        channel, message = params[:channel], params[:message]
        @irc_gateway.send_irc channel, message
        render :status => 200

      when 'create_vlan'
        the_vlan= Vlan.find(params[:id])
        @irc_gateway.create_vlan the_vlan
        render :status => 200

      when 'remove_vlan'
        #puerto_id, endpoint_id, practica_id= params[:puerto_id], params[:endpoint_id], params[:practica_id]
        the_vlan = Vlan.new(params[:vlan])
        @irc_gateway.remove_vlan the_vlan
        render :status => 200

      when 'reset_practica'
        the_practica = Practica.find(params[:id])
        @irc_gateway.reset_practica the_practica
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
