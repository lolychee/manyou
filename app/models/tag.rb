class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  #include TagParser

  field :name,              :type => String
  field :intro,             :type => String

  has_and_belongs_to_many :tags

  attr_accessible :name, :intro, :tags

  validates_uniqueness_of :name

  TagsRegex = /^([0-9a-zA-Z\u4e00-\u9fa5]+[\s\+]?)+$/

  TagRegex = /^[0-9a-zA-Z\u4e00-\u9fa5]$/

  def to_param
    self.name
  end

  def self.find_tags(tags)
    tags = self.string_to_array(tags) if tags.is_a? String
    tags = [] if tags.nil?
    tags.collect{|tag| self.find_or_create_by(:name => tag.downcase)}
  end

  def self.string_to_array(string)
    tags = string.split /[\s\+]+/
    #tags.map! {|tag| tag.gsub "/", ""}
    tags.delete_if {|tag| tag.size > 20 || tag.empty? }
  end

end
