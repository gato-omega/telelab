class PracticeJob < Struct.new(:practice_id, :transition)
  #Include the faye sender module to send...
  include CustomFayeSender
  def perform
    practica = Practica.find(practice_id)
    if transition.eql? :open
      practica.abrir
    elsif transition.eql? :close
      practica.cerrar
      #irc_gateway = IRCGateway.instance
      #irc_gateway.reset_devices_for practica
    end
  end
end
