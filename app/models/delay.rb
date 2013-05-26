class Delay
  include Mongoid::Document

  embedded_in :hospital
  field :minutes, type: Float, default: 0.0
  field :created_at, type: Time, default: ->{ Time.now }
  field :updated_at, type: Time, default: ->{ Time.now }

  validates_numericality_of :minutes, :greater_than_or_equal_to => 0
  validates_presence_of :hospital
  
  default_scope order_by(:created_at => :desc)

end
