class User < ApplicationRecord
  	rolify
	has_and_belongs_to_many :roles
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable
	validates :name,:email, presence: true

	has_one :address
	has_many :send_parcels, foreign_key: :sender_id, class_name: 'Parcel'
	has_many :received_parcels, foreign_key: :receiver_id, class_name: 'Parcel'

	accepts_nested_attributes_for :address
	after_create :assign_default_role
	after_save :set_default_created_by

	def name_with_address
		@name_with_address ||= [name, address.address_line_one, address.city, address.state, address.country, address.pincode].join('-')
	end

	private
	#set default role user
	def assign_default_role
		self.add_role(:user) if self.roles.blank?
	end

	#set default created by 
	def set_default_created_by
		if self.created_by.nil?
			self.update(created_by: self.id)
		end
	end
end
