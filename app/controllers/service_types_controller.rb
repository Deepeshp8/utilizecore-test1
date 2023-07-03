class ServiceTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service_type, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  # GET /service_types or /service_types.json
  def index
    @service_types = ServiceType.all.order("id desc").paginate(page: params[:page], per_page: 10)
  end

  # GET /service_types/1 or /service_types/1.json
  def show
  end

  # GET /service_types/new
  def new
    @service_type = ServiceType.new
  end

  # GET /service_types/1/edit
  def edit
  end

  # POST /service_types or /service_types.json
  def create
    @service_type = ServiceType.new(service_type_params)

    respond_to do |format|
      if @service_type.save
        format.html { redirect_to @service_type, notice: "Service type was successfully created." }
        format.json { render :show, status: :created, location: @service_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @service_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /service_types/1 or /service_types/1.json
  def update
    respond_to do |format|
      if @service_type.update(service_type_params)
        format.html { redirect_to @service_type, notice: "Service type was successfully updated." }
        format.json { render :show, status: :ok, location: @service_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @service_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_types/1 or /service_types/1.json
  def destroy
    @service_type.destroy
    respond_to do |format|
      format.html { redirect_to service_types_url, notice: "Service type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_type
      @service_type = ServiceType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def service_type_params
      params.require(:service_type).permit(:name)
    end
end
