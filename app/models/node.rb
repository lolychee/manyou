class Node
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,              :type => String
  field :index,             :type => String
  field :intro,             :type => String

  attr_accessible :name, :intro

  #has_and_belongs_to_many :nodes, :class_name => 'Tag'

  NodesRegex = /^([0-9a-zA-Z\u4e00-\u9fa5]+[\s\+]?)+$/

  NodeRegex = /^[0-9a-zA-Z\u4e00-\u9fa5]$/

  validate do
    errors.add(:name, :confirmation) if name.downcase != index
  end

  def to_param
    name
  end

  def topics
    Topic.find_by_nodes([_id])
  end

  def self.find_nodes(nodes)
    if nodes.is_a? String
      nodes = split_to_nodes(nodes)
    elsif nodes.is_a? Array
      nodes = filter_nodes(nodes)
    else
      return []
    end
    nodes.collect{|node| first(:conditions => {:index => node.downcase}) }.delete_if{|node| node.nil?}
  end

  def self.find_or_create_nodes(nodes)
    if nodes.is_a? String
      nodes = split_to_nodes(nodes)
    elsif nodes.is_a? Array
      nodes = filter_nodes(nodes)
    else
      return []
    end
    nodes.collect{|node| first(:conditions => {:index => node.downcase}) || create({:name => node, :index => node.downcase}) }
  end

  def self.split_to_nodes(string)
    nodes = string.split /[\s]+/
    #nodes.map! {|tag| tag.gsub "/", ""}
    filter_nodes(nodes)
  end

  def self.filter_nodes(nodes)
    nodes.delete_if {|node| node.size > 20 || node.empty? }
  end
end
