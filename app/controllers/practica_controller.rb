class PracticaController < ApplicationController
  def index
  end

  def ircchat
    @message = params[:message]
    @response = @message

    
    

    logger.debug "#################################### message #{@message}"
    logger.debug "#################################### response #{@response}"

    respond_to do |format|
      format.js
      format.xml  { render :xml => @message }
    end
  end

end
