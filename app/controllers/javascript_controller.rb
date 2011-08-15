class JavascriptController < ApplicationController

  #before_filter :authenticate_user!
  respond_to :js

  def faye_init
    if current_user
      @faye_channel = current_user.username
    else
      @faye_channel = "lobby"
    end
  end
end