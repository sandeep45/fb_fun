class FacebooksController < ApplicationController

  before_filter :setupFacebook


  def connect
    logger.info "in connect"
     
    perms_needed = ["read_mailbox",
                    "manage_pages",
                    "publish_stream",
                    "read_stream",
                    "read_friendlists",
                    "email",
                    "user_about_me"].join ","   

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

    begin
      atInfo = @oauth.get_access_token_info(params["code"])
      logger.info "access token info #{atInfo}"
      
      @graph = Koala::Facebook::API.new(atInfo["access_token"])
      profile = @graph.get_object("me")
      logger.info "facebook profile reads: #{ap profile}"

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
      logger.error "error while getting access token: #{e}"
      render :status => 200, :text => "unable to get access token: #{e}"
      return
    end

    render :status => 200, :text => "data captured. Thx"
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
