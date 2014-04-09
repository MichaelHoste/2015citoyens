# encoding: UTF-8

class UsersController < ApplicationController
  def update
    current_user.update_attributes(:description => params[:description])
    current_user.publish!
    MozaicService.delay.create()
    flash[:notice] = "Merci pour votre participation ! Vous apparaîtrez sur la mosaique dans quelques minutes."
    redirect_to :root
  end
end

