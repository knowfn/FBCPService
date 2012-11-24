class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user         # && user.authenticate(params[:session][:password])
            # TODO: Need to logout the previous user and acquire facebook token for this user
      sign_in user
      redirect_to user
    else
      flash.now[:error] = 'Invalid email'
      render 'new'
    end
  end

  def destroy
  end


end
