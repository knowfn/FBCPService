class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    Rails.logger.info("......user:show CALLED.....................")
    @user = User.find(params[:id])
    sign_in @user
    @fbposts = @user.facebookposts 
    @facebookpost = @user.facebookposts.build(params[:facebookpost])  
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to the FBCP!"
      redirect_to @user
    else
      render 'new'
    end
  end

end
