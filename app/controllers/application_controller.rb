class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  def setupFacebook
  	@oauth = Koala::Facebook::OAuth.new(ENV["FB_ID"],
  					ENV["FB_SECRET"],callback_facebooks_url)
  end

  def createNewFacebook(profile, atInfo, user)
  	user.emails.build :email => profile["email"] unless user.emails.where(:email => profile["email"]).exists?
        
    user.build_facebook :uid => profile["id"], :name => profile["name"],
        :username => profile["username"], :hometown => profile["hometown"]["name"],
        :gender => profile["gender"], :email => profile["email"],
        :verified => profile["verified"], :up_time => profile["updated_time"],
        :link => profile["link"], :timezone => profile["timezone"],
        :access_token => atInfo["access_token"],
        :expires_at => Time.now + atInfo["expires"].to_i
    
    works = profile["work"]
    works.each do |w| 
      puts "got this work #{ap w}"
    end

    user.save!
  end
  
  def updateFacebook(profile, atInfo, user)
  	user.emails.build :email => profile["email"] unless user.emails.where(:email => profile["email"]).exists?
        
    user.facebook.update_attributes :uid => profile["id"], :name => profile["name"],
        :username => profile["username"], :hometown => profile["hometown"]["name"],
        :gender => profile["gender"], :email => profile["email"],
        :verified => profile["verified"], :up_time => profile["updated_time"],
        :link => profile["link"], :timezone => profile["timezone"],
        :access_token => atInfo["access_token"],
        :expires_at => Time.now + atInfo["expires"].to_i
    
    works = profile["work"]
    works.each do |w| 
      puts "got this work #{ap w}"
    end

    user.save!
  end
end
