class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  include AutoIncrement

  ai_field :nid

  field :title,                 :type => String
  field :content,               :type => String
  field :hits,                  :type => Integer,   :default => 0
  field :status,                :type => String,    :default => 'normal'
  field :type,                  :type => String,    :default => 'topic'

  STATUS    = ['normal', 'ban']
  TYPE      = ['topic', 'question', 'share']

  field :tag

  field :mark_count,            :type => Integer,   :default => 0

  field :edited_at,             :type => Time,      :default => Time.now
  field :replied_at,            :type => Time,      :default => Time.now

  embeds_many :replies,         :class_name => 'TopicReply'

  has_and_belongs_to_many :tracker, :class_name => 'User'
  has_and_belongs_to_many :tags, :class_name => 'Tag'

  belongs_to :author,           :class_name => 'User', :inverse_of => 'topics'

  scope :find_by_author, ->(id) { where(:author_id => id) }
  scope :find_by_tags, ->(tag) { where(:tag_ids => Tag.find_tags(tag).collect{|tag| tag.id} )}

  attr_accessible :title, :content, :tag, :type


  validates_inclusion_of    :type,      :in => TYPE, :allow_blank => true
  validates_inclusion_of    :status,    :in => STATUS, :allow_blank => true

  def to_param
    nid.to_s
  end

  def self.tag_could
    map = <<EOF
function() {
    if (!this.index_tags) {
        return;
    }

    for (index in this.index_tags) {
        emit(this.index_tags[index], 1);
    }
}
EOF
    reduce = <<EOF
function(previous, current) {
    var count = 0;

    for (index in current) {
        count += current[index];
    }

    return count;
}
EOF
    collection.mapreduce(map, reduce, {:out => 'topic_tag_could'})
    rescue Mongo::OperationFailure
      []
  end

end
