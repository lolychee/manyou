class Forum
  include Mongoid::Document
  include Mongoid::Timestamps
  include AutoIncrement

  field :name,                  :type => String
  field :intro,                 :type => String
  field :alias,                 :type => String

  has_many :topics

  belongs_to :manager,          :class_name => :User

  validates_uniqueness_of :name, :intro, :alias

  def self.find_by_alias(id)
    first(:conditions => {:alias => /#{id}/i}) if id != nil
  end

  def self.find_by_param(id)
    find_by_alias(id)
  end

  def to_param
    self.alias
  end
end
