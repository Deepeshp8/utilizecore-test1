class Parcel < ApplicationRecord

	#status=pending Indicate Sender initiated parcel process
	STATUS = ['Pending','Sent', 'In Transit', 'Delivered']
	PAYMENT_MODE = ['COD', 'Prepaid']

	validates :weight, :status, presence: true
	validates :status, inclusion: STATUS
	validates :payment_mode, inclusion: PAYMENT_MODE
	validate :validate_sender_receiver

	belongs_to :service_type
	belongs_to :sender, class_name: 'User'
	belongs_to :receiver, class_name: 'User'

	after_create :send_notification
	after_update :send_parcel_update_notification
	after_destroy :send_parcel_cancel_notification

	#Validate Sender and Receiver should not be same
	def validate_sender_receiver
		errors.add(:base, "Sender and Receiver can't be same") if self.sender == self.receiver
	end

	private

	def send_notification
		UserMailer.with(parcel: self).status_email.deliver_later
	end

	#Process parcel status update notification
	def send_parcel_update_notification
		UserMailer.with(parcel: self).update_status_parcel_email.deliver_later
	end

	#Process parcel cancellation notification
	def send_parcel_cancel_notification
		UserMailer.with(parcel: self).parcel_cancel_email.deliver_later
	end

end
