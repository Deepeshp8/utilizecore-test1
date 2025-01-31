class Role < ApplicationRecord
  resourcify
  has_and_belongs_to_many :users, :join_table => :roles_users
  
  belongs_to :resource,
             :polymorphic => true,
             :optional => true
  

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify
end
