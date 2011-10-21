class PracticeJob < Struct.new(:practice_id, :transition)
  #Include the faye sender module to send...
  #include CustomFayeSender
  def perform
    practica = Practica.find(practice_id)
    if transition.eql? :abrir
      practica.abrir
      # Mandar la notification por faye de que esta abierta
    elsif transition.eql? :cerrar
      practica.cerrar
      # Mandar la notification por faye de que esta cerrada
    end
  end
end