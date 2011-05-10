class TopicReply
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content,           :type => String
  field :floor,             :type => Integer
  field :status,            :type => String

  field :voteup,            :type => Integer,   :default => 0
  field :votedown,          :type => Integer,   :default => 0

  embedded_in :topic

  belongs_to :author,       :class_name => 'User'

end
