class TopicReply
  include Mongoid::Document
  include Mongoid::Timestamps
  include Manyou::Vote

  field :content,           :type => String
  field :floor,             :type => Integer
  field :status,            :type => String

  embedded_in :topic

  belongs_to :author,       :class_name => 'User'

end
