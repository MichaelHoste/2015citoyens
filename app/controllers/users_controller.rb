class UsersController < ApplicationController
  def update
    current_user.update_attributes(:description => params[:description])
    current_user.publish!
    MozaicService.create()
    flash[:notice] = "Merci pour votre avis ! Vous apparaîtrez sur la mosaique dans quelques minutes."
    redirect_to :root
  end
end

