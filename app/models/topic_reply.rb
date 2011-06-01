class TopicReply
  include Mongoid::Document
  include Mongoid::Timestamps
  include Manyou::DB::Vote

  field :content,           :type => String
  field :floor,             :type => Integer
  field :status,            :type => String,    :default => 'normal'

  embedded_in :topic

  belongs_to :author,       :class_name => 'User'

  validates_presence_of     :content
  validates_presence_of     :author

end
