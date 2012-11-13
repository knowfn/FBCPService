class FacebookpostsController < ApplicationController
  
  
  def create
        Rails.logger.info("......current_user.....................")
        Rails.logger.info(current_user)
        
    @facebookpost = current_user.facebookposts.build(params[:facebookpost])
    if @facebookpost.save
      flash[:success] = "Facebook post created!"
      Rails.logger.info("..........Dumping new POST in fbcontroller:create......")
      Rails.logger.info(@facebookpost[:post])
      
      redirect_to current_user
    else
    end
  end

  def destroy
  end
end
