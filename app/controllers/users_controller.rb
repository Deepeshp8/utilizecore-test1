class UsersController < ApplicationController
  before_action :authenticate_user!,:except => %i[ create ]
  before_action :set_user, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  # GET /users or /users.json
  def index
    if current_user.has_role? :admin
      @users = User.all.order("id desc")
    else
      @users = User.where("created_by = ? and id != ?",current_user.id,current_user.id).order("id desc")
    end
    @users = @users.paginate(page: params[:page], per_page: 10)
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @user.build_address
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    if user_signed_in?
      @user.password = Devise.friendly_token.first(6)
      @user.created_by = current_user.id
      redirect_url = users_admin_index_path
    else
      redirect_url = root_path
    end 
    respond_to do |format|
      if @user.save
        format.html { redirect_to redirect_url, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        if user_signed_in?
          format.html { render :new, status: :unprocessable_entity }
        else
          format.html { redirect_to new_user_registration_path, notice: @user.errors.first.full_message  }
        end
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(update_user_params)
        format.html { redirect_to users_admin_index_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      if user_signed_in?
        params.require(:user).permit(:name, :email, address_attributes: [:address_line_one, :address_line_two,
                                                                       :city, :state, :country,
                                                                       :pincode, :mobile_number])
      else
        params.require(:user).permit(:name, :email,:password, :password_confirmation, address_attributes: [:address_line_one, :address_line_two,
          :city, :state, :country,
          :pincode, :mobile_number])
      end
    end

    # Only allow a list of trusted parameters while update user.
    def update_user_params
      params.require(:user).permit(:id ,:name, :email, address_attributes: [:id, :address_line_one, :address_line_two,
        :city, :state, :country,
        :pincode, :mobile_number])
    end
end
