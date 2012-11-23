class FacebookpostsController < ApplicationController
  
  
  def create
    Rails.logger.info("......facebookposts:create CALLED.....................")
    Rails.logger.info("Access_Token : ...........................")
    Rails.logger.info(session['access_token'])

       Rails.logger.info("......current_user.....................")
       Rails.logger.info(current_user)

    @facebookpost = current_user.facebookposts.build(params[:facebookpost])
        
    if session['access_token']
        @graph = Koala::Facebook::API.new(session["access_token"])
        
        Rails.logger.info(".......facebookposts:create about to post on FB wall........")
#        @graph.put_object("me", "feed", :message => "I am writing from posttowall on Oct 31st 5:05pm!", :link => 'http://www.iApprove.com', :picture => 'http://furious-spring-4433.herokuapp.com/greenCheck.png', :name => 'From iApprove Website', :description => 'Checkout iApprove website!')
        fb_post_id = @graph.put_wall_post(@facebookpost[:post])       
        Rails.logger.info("......FB Post ID = " + fb_post_id["id"])

        @facebookpost[:post_id] = fb_post_id["id"]
        if @facebookpost.save
          flash[:success] = "Facebook post created!"
          Rails.logger.info("..........Dumping new POST in fbcontroller:create......")
          Rails.logger.info(@facebookpost[:post])         
          redirect_to current_user
        else
          Rails.logger.info("........save to facebookposts DB FAILED..............")
        end
    else
      Rails.logger.info("........access_token missing in facebookposts#create..............")
    end

  end

  def destroy
  end
end
