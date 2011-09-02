module PracticasHelper

  def create_tabs dispositivos
    dispositivos.each do |device|
      concat content_tag(:li, content_tag(:a, "#{device.nombre}", :href => "#tabs-#{device.id}"))
    end
  end

  def create_content_tabs dispositivos
    dispositivos.each do |device|
      concat content_tag(:div, content_tag(:p, "#{device.nombre}"), :id => "tabs-#{device.id}")
    end
  end

  def create_consoles
    text_area(:irc, :area, :cols => 30, :rows => 10)
    #form_tag message_path, :remote => true, :id => 'chat' do
    label_tag(:message, "Mensaje:")
    text_field_tag(:message)
    submit_tag("Enviar")
  end

end