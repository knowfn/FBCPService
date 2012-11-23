class FacebooksController < ApplicationController

  APP_ID="166864856786067"
  APP_SECRET="1b681b2579723f696c48775a6d8a302a"
  SITE_URL="http://localhost:3000/"
#  SITE_URL="http://blooming-oasis-4471.herokuapp.com/"
  
  def index
    Rails.logger.info("index CALLED ...........................")
    if session['access_token']
      @face='You are logged in! <a href="/logout">Logout</a>'      
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
    Rails.logger.info("logout CALLED ...........................")
    session['oauth'] = nil
    session['access_token'] = nil
    redirect_to '/menu'
  end

#method to handle the redirect from facebook back to you
  def callback
    #get the access token from facebook with your code
    Rails.logger.info("callback CALLED ...........................")

    session['access_token'] = session['oauth'].get_access_token(params[:code])

    Rails.logger.info("Access_Token : ...........................")
    Rails.logger.info(session['access_token'])
    redirect_to '/menu'
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
