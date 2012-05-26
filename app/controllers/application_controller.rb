class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  def setupFacebook
  	@oauth = Koala::Facebook::OAuth.new(ENV["FB_ID"],
  					ENV["FB_SECRET"],callback_facebooks_url)
  end
end
