# FayeMessagesController is an AbstractController that
# allows usage of rendering javascript templates to
# send Faye Messages eval javascript to browsers
# Define your faye message in the corresponding view!
class FayeMessagesController < AbstractController::Base

  include AbstractController::Rendering
  include AbstractController::Layouts
  include AbstractController::Helpers
  include AbstractController::Translation
  include AbstractController::AssetPaths
  include ActionController::UrlWriter

  # Uncomment if you want to use helpers defined in ApplicationHelper in your views
  # helper ApplicationHelper
  helper PracticasHelper

  # Make sure your controller can find views
  self.view_paths = "app/views"

  # You can define custom helper methods to be used in views here
  # helper_method :current_admin
  # def current_admin; nil; end

  def whatever(lool)
    @lol = "rvalue> (#{lool})"
    #The following line is necessary
    render template: "faye_messages/whatever"
    # or, for partials:
    # render partial: "hello_world/show"
  end

  #Normal method for testing
  def normal_method_is(something)
    whatever("your param here> #{something}")
  end

  # Generates a console terminal output, when received from device channel
  def generate_terminal_output(device_id, message)
    @device_id = device_id
    @mensaje = message
    render template: "faye_messages/terminal"
  end

  #Generates console terminal output, when a user sends to a device channel (echo)
  def generate_terminal_user_output(mensaje)
    @mensaje = mensaje
    @terminal_id = (@mensaje[:channel].split '_').last
    render template: "faye_messages/terminal_user"
  end

  #Generates chat output for the pratice channel
  def generate_chat_output(mensaje)
    @mensaje = mensaje
    render template: "faye_messages/chat"
  end

  #Generates chat output for the pratice channel
  def generate_chat_status_output(user_id, status)
    @user_id = user_id
    @status = status
    render template: "faye_messages/chat_status"
  end

  def generate_remove_conexion_output(vlan)
    # remove the thing with id vlan.id
    @vlan = vlan
    @id = vlan.id
    render template: "faye_messages/remove_connection"
  end

  def generate_new_conexion_output(vlan)
    @vlan =  vlan
    @vlan_hash = {}
    @practica = @vlan.practica
    @vlan_hash[:practica_id] = @practica.id
    @vlan_hash[:id] = @vlan.id
    @vlan_hash[:puerto] = @vlan.puerto.fullname
    @vlan_hash[:endpoint] = @vlan.endpoint.fullname

    @conexiones = vlan.practica.vlans

    render template: "faye_messages/new_conexion"
  end

  def generate_new_conexion_error_output(vlan)
    render template: "faye_messages/new_conexion_error"
  end

end
