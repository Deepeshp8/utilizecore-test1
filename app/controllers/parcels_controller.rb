class ParcelsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_parcel, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  # GET /parcels or /parcels.json
  def index
    if current_user.has_role? :admin
      @parcels = Parcel.all.order("id desc")
    else
      @parcels = Parcel.where("created_by = ?",current_user.id).order("id desc")
    end
    @parcels = @parcels.paginate(page: params[:page], per_page: 10)
  end

  # GET /parcels/1 or /parcels/1.json
  def show
  end

  # GET /parcels/new
  def new
    @parcel = Parcel.new
    if current_user.has_role? :admin
      @users = User.all.order("id desc")
    else
      @users = User.where("created_by = ?",current_user.id).order("id desc")
    end
    @users = @users.map{|user| [user.name_with_address, user.id]}
    @service_types = ServiceType.all.map{|service_type| [service_type.name, service_type.id]}
  end

  # GET /parcels/1/edit
  def edit
    if current_user.has_role? :admin
      @users = User.all.order("id desc")
    else
      @users = User.where("created_by = ?",current_user.id).order("id desc")
    end
    @users = @users.map{|user| [user.name_with_address, user.id]}
    @service_types = ServiceType.all.map{|service_type| [service_type.name, service_type.id]}
  end

  # POST /parcels or /parcels.json
  def create
    @parcel = Parcel.new(parcel_params)
    if current_user.has_role? :user
      @parcel.status = 'Pending'
    end
    @parcel.created_by = current_user.id
    respond_to do |format|
      if @parcel.save
        format.html { redirect_to @parcel, notice: 'Parcel was successfully created.' }
        format.json { render :show, status: :created, location: @parcel }
      else
        format.html do
          if current_user.has_role? :admin
            @users = User.all.order("id desc")
          else
            @users = User.where("created_by = ?",current_user.id).order("id desc")
          end
          @users = @users.map{|user| [user.name_with_address, user.id]}
          @service_types = ServiceType.all.map{|service_type| [service_type.name, service_type.id]} 
          render :new, status: :unprocessable_entity
        end
        format.json { render json: @parcel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parcels/1 or /parcels/1.json
  def update
    respond_to do |format|
      if @parcel.update(parcel_params)
        format.html { redirect_to @parcel, notice: 'Parcel was successfully updated.' }
        format.json { render :show, status: :ok, location: @parcel }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @parcel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parcels/1 or /parcels/1.json
  def destroy
    @parcel.destroy
    respond_to do |format|
      format.html { redirect_to parcels_url, notice: 'Parcel was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parcel
      @parcel = Parcel.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def parcel_params
      if current_user.has_role? :admin
        params.require(:parcel).permit(:weight, :status, :service_type_id,
                                     :payment_mode, :sender_id, :receiver_id,
                                     :cost)
      else
        params.require(:parcel).permit(:weight, :service_type_id,
          :payment_mode, :sender_id, :receiver_id,:cost)
      end

    end
end
