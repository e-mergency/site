class RolesUser
  include Mongoid::Document

  belongs_to :user
  belongs_to :role
end
