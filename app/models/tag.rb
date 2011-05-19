class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,              :type => String
  field :index,             :type => String
  field :tag,               :type => String

  has_and_belongs_to_many :tags, :class_name => 'Tag'

  TagsRegex = /^([0-9a-zA-Z\u4e00-\u9fa5]+[\s\+]?)+$/

  TagRegex = /^[0-9a-zA-Z\u4e00-\u9fa5]$/

  def self.find_tags(tags)
    if tags.is_a? String
      tags = split_to_tags(tags)
    elsif tags.is_a? Array
      tags = filter_tags(tags)
    else
      return []
    end
    where(:index => {:in => tags.collect{|tag| tag.downcase}}).all
  end

  def find_or_create_tags(tags)
    if tags.is_a? String
      tags = split_to_tags(tags)
    elsif tags.is_a? Array
      tags = filter_tags(tags)
    else
      return []
    end
    tags.collect{|tag| first(:conditions => {:index => tag.downcase}) || create({:name => tag, :index => tag.downcase}) }
  end

  def self.split_to_tags(string)
    tags = string.split /[\s\+]+/
    #tags.map! {|tag| tag.gsub "/", ""}
    tags.delete_if {|tag| tag.size > 20 || tag.empty? }
  end

  def self.filter_tags(tags)
  end
end
