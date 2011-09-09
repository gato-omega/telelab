module PracticasHelper


  def device_consoles(dispositivos)
    out = content_tag(:ul, (create_tabs dispositivos))
    out += create_tabs_content dispositivos
  end

  private
  def create_tabs dispositivos
    out = ""
    dispositivos.each do |device|
      out += content_tag(:li, content_tag(:a, "#{device.nombre}", :href => "#tabs-#{device.id}"))
    end
    out.html_safe
  end

  def create_tabs_content dispositivos
    out = ""
    dispositivos.each do |dispositivo|
      out += content_tag(:div, (device_console_form dispositivo), :id => "tabs-#{dispositivo.id}")
    end
    out.html_safe
  end

  def create_consoles
    text_area(:irc, :area, :cols => 30, :rows => 10)
    #form_tag message_path, :remote => true, :id => 'chat' do
    label_tag(:message, "Mensaje:")
    text_field_tag(:message)
    submit_tag("Enviar")
  end

  def device_console_form(dispositivo)
    form_tag 'practica/message'
    content_tag(:p, "#{dispositivo.nombre}")
  end

end