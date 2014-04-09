class UsersController < ApplicationController
  def update
    current_user.update_attributes(:description => params[:description])
    current_user.publish!
    MozaicService.create()
    redirect_to :root
  end
end

