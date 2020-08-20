class HomeController < ApplicationController

  def index
    if current_organization && policy(current_organization).manage?  
      redirect_to good_requests_path and return
    elsif current_organization
      @good_requests = current_user.good_requests.all
      @good_requests_as_holder = GoodRequest.where(holder_id: current_user.id).all
      @good_requests_as_holder -= @good_requests 
    else
      redirect_to root_path(__org__: 'mat')
    end
  end

end



