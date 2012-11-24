class FacebooksController < ApplicationController

if Rails.env.development?
  APP_ID="526770297333543"
  APP_SECRET="225049e92a0e0d5690717a00813398c1"
#  SITE_URL="http://localhost:3000/"
end
if Rails.env.production?
  APP_ID="166864856786067"
  APP_SECRET="1b681b2579723f696c48775a6d8a302a"
#  SITE_URL="http://blooming-oasis-4471.herokuapp.com/"
end

  def index
    Rails.logger.info("index CALLED ...........................")
    Rails.logger.info(APP_ID)
    Rails.logger.info(APP_SECRET)
    Rails.logger.info(SITE_URL)
    Rails.logger.info(XSITEURL)
    Rails.logger.info("index ...........................")
    
    if session['access_token']
      @face='You are logged in! <a href="/logout">Logout</a>'
      
      #GET lookup data from facebook
      @graph = Koala::Facebook::API.new(session["access_token"])
      facebook_user = @graph.get_object("me")
      Rails.logger.info(facebook_user)
      user_email = facebook_user["username"]+"@facebook.com"
      Rails.logger.info(user_email)
      
      user = User.find_by_email(user_email)
      if user
        Rails.logger.info(user.name)
        Rails.logger.info(user.email)
        redirect_to user    # fetch the posts and display them and allow the user to post new ones
      else
          # Ideally this should never be invoked since access_token is obtained only for the user who are already in the Users DB and identified by email
        @face='<a href="/login">Facebook Login</a>'
      end      
    else
      @face='<a href="/login">Facebook Login</a>'
    end
  end

  def login
    Rails.logger.info("login CALLED ...........................")
    # generate a new oauth object with your app data and your callback url
    session['oauth'] = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET, SITE_URL + '/callback')

    # redirect to facebook to get your code
    redirect_to session['oauth'].url_for_oauth_code(:permissions => "publish_stream, read_stream, user_likes")
  end

  def logout
    Rails.logger.info("logout CALLED ...........................")
    session['oauth'] = nil
    session['access_token'] = nil
    redirect_to '/index'
    #TODO: Redirecting to index will invoke login which the user will click. Since browser is still logged into facebook,
    #this app will automatically log back into same user.
    
  end

#method to handle the redirect from facebook back to you
  def callback
    #get the access token from facebook with your code
    Rails.logger.info("callback CALLED ...........................")

    session['access_token'] = session['oauth'].get_access_token(params[:code])

    Rails.logger.info("Access_Token : ...........................")
    Rails.logger.info(session['access_token'])

      #Lookup data from facebook
      @graph = Koala::Facebook::API.new(session["access_token"])
      facebook_user = @graph.get_object("me")
      Rails.logger.info(facebook_user)
      user_email = facebook_user["username"]+"@facebook.com"
      Rails.logger.info(user_email)
      
      user = User.find_by_email(user_email)
      if user
        Rails.logger.info("PRE-REGISTERED USER.............")
        Rails.logger.info(user.name)
        Rails.logger.info(user.email)
        redirect_to user    # fetch the posts and display them and allow the user to post new ones
      else
          # This user is signin up for the service, create a new entry for user in User DB
        Rails.logger.info("..........Create NEW USER in User DB with handle = " + user_email)
        @user = User.new({"name"=>facebook_user["username"], "email"=>user_email})
        if @user.save
          flash[:success] = "Welcome to the FBCP!"
          redirect_to @user
        else
          Rails.logger.info("........save to Users DB FAILED..............")
          redirect_to '/logout'
        end

      end
  end

  def menu
     @ok="you are welcome"
     Rails.logger.info("menu CALLED ...........................")
     if session['access_token']
       @face='You are logged in! <a href="/logout">Logout</a> | <a href="/posttowall">Post Something to the Wall</a> | <a href="/getposts">Display Posts</a> '
      else
       @face='<a href="/login">Login</a>'
     end

  end

  def posttowall
     Rails.logger.info("posttowall CALLED ...........................")
     if session['access_token']
        @graph = Koala::Facebook::API.new(session["access_token"])
        
        Rails.logger.info("posttowall about to post on FB...........................")
#        @graph.put_object("me", "feed", :message => "I am writing from posttowall on Oct 31st 5:05pm!", :link => 'http://www.iApprove.com', :picture => 'http://furious-spring-4433.herokuapp.com/greenCheck.png', :name => 'From iApprove Website', :description => 'Checkout iApprove website!')
        @graph.put_wall_post("I am posting on Thu Nov 14th at 12:33pm!!!!!!!")       
     else
        @face='<a href="/login">Login</a>'
     end
     redirect_to '/menu'
  end

  def getposts
     Rails.logger.info("getposts CALLED ...........................")

     if session['access_token']
        @graph = Koala::Facebook::API.new(session["access_token"])
        Rails.logger.info("getposts about to get from FB...........................")
        Rails.logger.info("Access_Token : ...........................")
        Rails.logger.info(session['access_token'])
        
        Rails.logger.info("...........................")
        @me = @graph.get_object("sb.knowfn")
        Rails.logger.info(@me)
        Rails.logger.info("...........................")
        @UserPosts = @graph.get_connections("me", "feed")
        Rails.logger.info(@UserPosts[0])
     else
        @face='<a href="/login">Login</a>'
     end
#     redirect_to '/menu'
  end

end
