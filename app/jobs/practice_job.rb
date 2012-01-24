class PracticeJob < Struct.new(:practice_id, :transition)
  #Include the faye sender module to send...
  include CustomFayeSender
  def perform
    practica = Practica.find(practice_id)
    if transition.eql? :open
      practica.dispositivos.each do |dispositivo|
        dispositivo.set_ready
        RemoteIRCGateway.instance.send_reset_token dispositivo, 'false'
      end
      practica.abrir
    elsif transition.eql? :close
      practica.cerrar
      mensaje_raw = FayeMessagesController.new.generate_close_pratica_output practica
      send_via_faye "#{FAYE_CHANNEL_PREFIX}#{practica.faye_channel}", mensaje_raw
      begin
        practica.dispositivos.each do |dispositivo|
         dispositivo.reset
        end
        RemoteIRCGateway.instance.reset_practica practica
      rescue => e
        puts "Exception in Practice Job for IRCGateway> #{e.message}"
      end
    end
  end
end
