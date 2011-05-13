class TopicMedia
  include Mongoid::Document

  field :name,          :type => String
  field :sort,          :type => Integer
  field :desc,          :type => String
  field :content_type,  :type => String

end
