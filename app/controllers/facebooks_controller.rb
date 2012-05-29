class FacebooksController < ApplicationController

  before_filter :setupFacebook


  def connect
    logger.info "in connect"
     
    perms_needed = ["user_about_me",
                    "user_activities",
                    "user_birthday",
                    "user_checkins",
                    "user_education_history",
                    "user_events",
                    "user_groups",
                    "user_hometown",
                    "user_interests",
                    "user_likes",
                    "user_location",
                    #"user_notes",
                    #"user_photos",                    
                    #"user_questions",
                    "user_relationships",
                    "user_relationship_details",
                    "user_religion_politics",
                    "user_status",
                    "user_subscriptions",
                    "user_videos",
                    "user_website",
                    "user_work_history",
                    "email",
                    "friends_about_me",
                    "friends_activities",
                    "friends_birthday",
                    "friends_checkins",
                    "friends_education_history",
                    "friends_events",
                    "friends_groups",
                    "friends_hometown",
                    "friends_interests",
                    "friends_likes",
                    "friends_location",
                    "friends_notes",
                    "friends_photos",                    
                    "friends_questions",
                    "friends_relationships",
                    "friends_relationship_details",
                    "friends_religion_politics",
                    "friends_status",
                    "friends_subscriptions",
                    "friends_videos",
                    "friends_website",
                    "friends_work_history",
                    "email",
                    "read_mailbox",
                    #"read_requests",
                    "read_stream"].join ","   

    redirect_to @oauth.url_for_oauth_code(:scope => perms_needed)
  end 

  def callback
    logger.info "in callback with #{params.inspect}"

    logger.info "got code #{params[:code]}"

    if params[:error].present?
      logger.info "error: #{params[:error]}"
      logger.info "error reason: #{params[:error_reason]}"
      logger.info "error description: #{params[:error_description]}"

      render :status => 200, :text => "Can not proceed. #{params[:error_description]}"
      return
    end

    atInfo = @oauth.get_access_token_info(params["code"])
    logger.info "access token info #{atInfo}"
    
    @graph = Koala::Facebook::API.new(atInfo["access_token"])

    result = {}

    t1 = Time.now

    @result = @graph.fql_multiquery(
      :basic => "select friend_count, education, work, birthday_date, hometown_location, sports," +
                " favorite_athletes, favorite_teams, likes_count, inspirational_people, email, music," +
                " tv, books, pic_square, affiliations, profile_update_time, political," +
                " activities, interests, profile_url, verified, family, website" +
                " from user where uid = me()",
      :checkins => "SELECT name, fan_count, price_range, attire, location, checkins, fan_count" +
                " FROM page WHERE page_id IN (select page_id from checkin where author_uid = me())",
      :events => "SELECT name, venue, location, start_time FROM event"+
                 " where eid IN (select eid from event_member where uid = me())",
      :groups => "select gid, name, description, venue, office  from group"+
                 " where gid IN (select gid from group_member where uid = me())" ,
      :links => "select url, share_count, like_count, comment_count, total_count"+
                " FROM link_stat where url IN (SELECT url FROM link WHERE owner=me())",
      :pages => "select name, fan_count"+
                " FROM page where page_id IN (SELECT page_id from page_admin WHERE uid=me())",         
      :posts => "SELECT post_id, comments, likes FROM stream WHERE source_id = me()"
    )

    t2 = Time.now

    @time_taken = t2 - t1

    # profile = @graph.get_object("me")
    # friends = @graph.get_connections("me", "friends")
    # feed = @graph.get_connections("me", "feed")
    # checkins = @graph.get_connections("me", "checkins")
    # inbox = @graph.get_connections("me","inbox")
    # interests = @graph.get_connections("me","interests")
    # likes = @graph.get_connections("me","likes")
    # logger.info "facebook profile reads: #{ap profile}"


    # f = Facebook.find_by_uid(profile["id"])
    # if f.present?
    #   logger.info "facebook profile already present, should update"
    #   user = f.user
    #   updateFacebook(profile,atInfo,user)
    #   message = "data updated. Thx"
    # else #TODO rather than creating a user search for a user as it may have been created via twitter, linked in etc. search could be via email, name etc.
    #   logger.info "no such facebook profile exists."
    #   user = User.create :name => profile["name"]
    #   createNewFacebook(profile,atInfo,user)
    #   message = "data captured. Thx"
    # end

    render "show"
  end 





  # GET /facebooks
  # GET /facebooks.json
  def index
    @facebooks = Facebook.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @facebooks }
    end
  end

  # GET /facebooks/1
  # GET /facebooks/1.json
  def show
    @facebook = Facebook.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @facebook }
    end
  end

  # GET /facebooks/new
  # GET /facebooks/new.json
  def new
    @facebook = Facebook.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @facebook }
    end
  end

  # GET /facebooks/1/edit
  def edit
    @facebook = Facebook.find(params[:id])
  end

  # POST /facebooks
  # POST /facebooks.json
  def create
    @facebook = Facebook.new(params[:facebook])

    respond_to do |format|
      if @facebook.save
        format.html { redirect_to @facebook, notice: 'Facebook was successfully created.' }
        format.json { render json: @facebook, status: :created, location: @facebook }
      else
        format.html { render action: "new" }
        format.json { render json: @facebook.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /facebooks/1
  # PUT /facebooks/1.json
  def update
    @facebook = Facebook.find(params[:id])

    respond_to do |format|
      if @facebook.update_attributes(params[:facebook])
        format.html { redirect_to @facebook, notice: 'Facebook was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @facebook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /facebooks/1
  # DELETE /facebooks/1.json
  def destroy
    @facebook = Facebook.find(params[:id])
    @facebook.destroy

    respond_to do |format|
      format.html { redirect_to facebooks_url }
      format.json { head :ok }
    end
  end
end
