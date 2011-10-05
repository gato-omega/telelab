module PracticasHelper

  def device_consoles(dispositivos)
    out = content_tag(:ul, (create_tabs dispositivos))
    out += create_tabs_content dispositivos
  end

  private
  def create_tabs dispositivos
    out = ""
    dispositivos.each do |device|
      out += content_tag(:li, content_tag(:a, "#{device.nombre}", :href => "#device_tab_#{device.id}"), :id => "tab#_#{device.id}")
    end
    out.html_safe
  end

  def create_tabs_content dispositivos
    out = ""
    dispositivos.each do |dispositivo|
      out += content_tag(:div, (device_console dispositivo), :id => "device_tab_#{dispositivo.id}")
    end
    out.html_safe
  end

  def device_console(dispositivo)
    content_tag :div, '', :id => "device_#{dispositivo.id}", :class => 'device_console'
  end

  # Faye client initialization and perform itearation over the channels provided
  # block gets captured so that javascript can be specified in destination view.
  def subscribe_to_faye_channels(client_name='faye_client', channels, &block)
    js_out="var #{client_name} = new Faye.Client('#{FAYE_SERVER_URL}');\n"
    channels.each do |channel|
      #js_out << "#{client_name}.subscribe('#{channel}', function(data){ #{block_js} });"
      js_out << "    "+(subscribe_to_faye_channel client_name, true, channel, &block)
      js_out << "\n"
    end
    js_out
  end

  def subscribe_to_faye_channel(client_name='faye_client', client_exists, channel, &block)
    block_js = ''
    block_js = capture(&block) if block_given?
    "#{client_name}.subscribe('#{channel}', function(data){ #{block_js} });"
  end

  def user_chat_status_icon(user, channel)
    # The images http://en.wikipedia.org/wiki/User:Science4sail/Status/StatusTemplate
    if user.chat_status(channel).eql? :available
      image_tag 'icons/status_available.png'
    elsif user.chat_status(channel).eql? :away
      image_tag 'icons/status_away.png'
    elsif user.chat_status(channel).eql? :offline
      image_tag 'icons/status_offline.png'
    end
  end

  def user_chat_status_icon_by_status(status)
    # The images http://en.wikipedia.org/wiki/User:Science4sail/Status/StatusTemplate
    if status.is_a? String
      status = status.to_sym
    end
    if status.eql? :available
      #image_tag 'icons/status_available.png'
      #"available"
      #(content_tag :img, :src => 'icons/status_available.png')
      tag :img, :src => '/images/icons/status_available.png'
    elsif status.eql? :away
      #image_tag 'icons/status_away.png'
      #"away"
      #(content_tag :img, :src => 'icons/status_away.png')
      tag :img, :src => '/images/icons/status_away.png'
    elsif status.eql? :offline
      #image_tag 'icons/status_offline.png'
      tag :img, :src => '/images/icons/status_offline.png'
    else
      #image_tag 'icons/status_offline.png'
      tag :img, :src => '/images/icons/status_offline.png'
    end
  end

end