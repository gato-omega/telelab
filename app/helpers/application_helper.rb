module ApplicationHelper

  def ui_flash(name, msg)

    if name.eql? :notice
      f_title    = 'Info'
      state_type = :highlight
      icon_type  = :info
    elsif name.eql? :error
      f_title    = 'Error'
      icon_type  = :error
      state_type = :error

    elsif name.eql? :alert
      f_title    = 'Alert'
      icon_type  = :error
      state_type = :error
    end

    "<div class=\"ui-widget\">
        <div class=\"ui-state-#{state_type} ui-corner-all\" style=\"padding: 0 .7em; margin: 10px\">
          <p><span class=\"ui-icon ui-icon-#{icon_type}\" style=\"float: left; margin-right: .3em;\"></span>
            <strong>#{f_title}: </strong>#{msg}</p>
        </div>
      </div>".html_safe
  end

end
