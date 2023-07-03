class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def status_email
    @parcel = params[:parcel]
    @sender = @parcel.sender
    @receiver = @parcel.receiver
    @url  = 'http://localhost:3000/search'
    mail(to: @receiver.email, cc: @sender.email,  subject: 'New Parcel Information')
  end

  #parcel status update notification
  def update_status_parcel_email
    @parcel = params[:parcel]
    @sender = @parcel.sender
    @receiver = @parcel.receiver
    @url  = 'http://localhost:3000/search'
    mail(to: @receiver.email, cc: @sender.email,  subject: 'Parcel Update')
  end

  #parcel cancellation notification
  def parcel_cancel_email
    @parcel = params[:parcel]
    @sender = @parcel.sender
    @receiver = @parcel.receiver
    @url  = 'http://localhost:3000'
    mail(to: @sender.email, cc: @receiver.email,  subject: 'Parcel Cancelled')
  end
end
