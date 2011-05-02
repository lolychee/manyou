class Reply
  include Mongoid::Document
  include Mongoid::Timestamps
  include AutoIncrement

  field :content,                   :type => String
  field :up,                        :type => Integer,       :default => 0
  field :floor,                     :type => Integer,       :default => 0

  embedded_in :topic

  belongs_to :author,                 :class_name => 'User'

  def on_up
    self.up += 1
    save
  end


end
