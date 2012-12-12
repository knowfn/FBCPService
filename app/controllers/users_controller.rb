class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    Rails.logger.info("......user:show CALLED.....................")
    Rails.logger.info("Access_Token : ...........................")
    Rails.logger.info(session['access_token'])

    @user = User.find(params[:id])
    sign_in @user
    @fbposts = @user.facebookposts 
    @facebookpost = @user.facebookposts.build(params[:facebookpost])  
      if session['access_token']
        @graph = Koala::Facebook::API.new(session["access_token"])
        Rails.logger.info("getposts about to get from FB...........................")
        Rails.logger.info("Access_Token : ...........................")
        Rails.logger.info(session['access_token'])
        
#        Rails.logger.info("...........................")
#        @me = @graph.get_object("sb.knowfn")
#        Rails.logger.info(@me)
        Rails.logger.info("...........................")
        @RcvdPosts = @graph.get_connections("me", "home")
        Rails.logger.info(@RcvdPosts[0])

        @SelfPosts = @graph.get_connections("me", "feed")
        Rails.logger.info(@SelfPosts[0])
     else
        Rails.logger.info("........access_token missing in user#show.................")
     end

    respond_to do |format|
      format.html #show.html.erb
      format.xml  { render :xml => @RcvdPosts }
      format.json { render :json => @RcvdPosts }
    end

 
  end

  def create
    Rails.logger.info("........UsersController#create ...")
    Rails.logger.info(params[:user])
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to the FBCP!"
      redirect_to @user
    else
      render 'new'
    end
  end

end
