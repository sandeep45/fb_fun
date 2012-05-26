class UsersController < ApplicationController

  before_filter :setupFacebook

  def connect
    logger.info "in connect"
     
    perms_needed = "read_mailbox,manage_pages,publish_stream,read_stream"+
                      ",read_friendlists,email,user_about_me"   

    redirect_to @oauth.url_for_oauth_code(:scope => perms_needed)
  end 

  def callback
    logger.info "in callback with #{params.inspect}"

    logger.info "got code #{params["code"]}"

    begin
      atInfo = @oauth.get_access_token_info(params["code"])
      logger.info "access token info #{atInfo}"
      
      @graph = Koala::Facebook::API.new(atInfo["access_token"])
      profile = @graph.get_object("me")
      logger.info "facebook profile reads: #{profile}"

      # if @provider.facebook.present?
      #   logger.info "this user already has a facebook auth present. updating access token"
      #   @provider.facebook.update_attributes :access_token => atInfo["access_token"],
      #       :uid => profile["id"], :expires_at => Time.now + atInfo["expires"].to_i,
      #       :profile_name => profile["name"]
      # else
      #   logger.info "creating facebook auth for this user"
      #   @provider.facebook = Facebook.create :access_token => atInfo["access_token"],
      #       :uid => profile["id"], :expires_at => Time.now + atInfo["expires"].to_i,
      #       :profile_name => profile["name"]
    rescue => e
      logger.error "unable to get access token: #{e}"
      redirect_to root_path
      return
    end

    redirect_to users_path()
  end 

  def start
    logger.info "in start of user"
  end


  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end
end
