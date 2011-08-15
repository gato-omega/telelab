class PracticaController < ApplicationController

  #before_filter :load_bot, :only => [:ircchat]

  def index
  end

  def ircchat
    if current_user
      @faye_channel = current_user.username
    else
      @faye_channel = "lobby"
    end
    @message = params[:message]
  end

end