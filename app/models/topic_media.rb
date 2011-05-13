class TopicMedia
  include Mongoid::Document

  field :name,          :type => String
  field :url,           :type => String
  field :file
  field :content_type,  :type => String
  field :desc,          :type => String
  field :sort,          :type => Integer

  embedded_in :topic
end
