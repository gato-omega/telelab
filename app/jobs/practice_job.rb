class PracticeJob < Struct.new(:practice_id, :transition)
  #Include the faye sender module to send...
  include CustomFayeSender
  def perform
    practica = Practica.find(practice_id)
    if transition.eql? :open
      practica.dispositivos.each do |dispositivo|
        dispositivo.set_ready
      end
      practica.abrir

    elsif transition.eql? :close
      practica.cerrar
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
