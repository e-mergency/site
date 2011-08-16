class Delay < ActiveRecord::Base
  belongs_to :hospital

  validates_numericality_of :minutes, :greater_than_or_equal_to => 0.0
  validates_presence_of :hospital
  
  default_scope :order => 'created_at DESC'
end
