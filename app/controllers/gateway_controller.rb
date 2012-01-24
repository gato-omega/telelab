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
        #puerto_id, endpoint_id, practica_id = params[:puerto_id], params[:endpoint_id], params[:practica_id]
        #puerto = Puerto.find(puerto_id)
        #endpoint = Puerto.find(endpoint_id)
        #practica = Puerto.find(practica_id)
        the_vlan = Vlan.find(params[:id])
        #the_vlan.puerto = puerto
        #the_vlan.endpoint = endpoint
        #the_vlan.practica = practica

        #the_vlan = Vlan.new(params[:vlan])
        @irc_gateway.remove_vlan the_vlan
        if the_vlan.destroy
          render :status => 200
        else
          render :status => 500
        end

      when 'reset_practica'
        the_practica = Practica.find(params[:id])
        @irc_gateway.reset_practica the_practica
        render :status => 200

      when 'initialize_vlan_switch'
        @irc_gateway.initialize_vlan_switch
        render :status => 200

      when 'send_reset_token'
        dispositivo = Dispositivo.find(params[:id])
        if params[:status].eql? 0
          status = false
        else
          status = true
        end
        @irc_gateway.send_reset_token dispositivo, status
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
