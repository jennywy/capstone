# frozen_string_literal: true

class AppointmentsController < ProtectedController
  before_action :set_appointment, only: %i[update destroy]

  # GET /appointments
  # GET /appointments.json
  def index
    @appointments = current_user.appointments.all

    render json: @appointments
  end

  # GET /appointments/1
  # GET /appointments/1.json
  def show
    render json: Appointment.find(params[:id])
  end

  # POST /appointments
  # POST /appointments.json
  def create
    Time.zone = appointment_params[:time_zone]
    @appointment = current_user.appointments.build(appointment_params)

    if @appointment.save
      render json: @appointment, status: :created
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /appointments/1
  # PATCH/PUT /appointments/1.json
  def update
    if @appointment.update(appointment_params)
      head :no_content
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /appointments/1
  # DELETE /appointments/1.json
  def destroy
    @appointment.destroy

    head :no_content
  end

  def set_appointment
    @appointment = current_user.appointments.find(params[:id])
  end

  def appointment_params
    params.require(:appointment).permit(:name, :phone_number, :time, :reminder)
  end

  private :set_appointment, :appointment_params
end
