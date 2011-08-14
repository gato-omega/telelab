class PracticaController < ApplicationController

  #before_filter :load_bot, :only => [:ircchat]

  def index
  end

  def ircchat
    @message = params[:message]
    respond_to do |format|
      format.js
      format.xml { render :xml => @message }
    end
  end

end
