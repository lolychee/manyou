class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  include AutoIncrement
  include TagParser
  include ContactModule

  ai_field :nid

  field :title,                 :type => String
  field :content,               :type => String
  field :hits,                  :type => Integer,   :default => 0
  field :status,                :type => String,    :default => 'normal'
  field :type,                  :type => String,    :default => 'topic'

  STATUS    = ['normal', 'ban']
  TYPE      = ['topic', 'question', 'share']

  tag_field :tag

  field :mark_count,            :type => Integer,   :default => 0

  field :edited_at,             :type => Time,      :default => Time.now
  field :replied_at,            :type => Time,      :default => Time.now

  embeds_many :replies
  contact_field :track

  belongs_to :author,           :class_name => 'User'

  scope :find_by_author, ->(id) { where(:author_id => id) }
  scope :find_by_tag, ->(tag) { where(:index_tags => Tag.find_tags(tag).collect{|tag| tag.id} )}

  attr_accessible :title, :content, :tag, :type


  validates_inclusion_of    :type,      :in => TYPE, :allow_blank => true
  validates_inclusion_of    :status,    :in => STATUS, :allow_blank => true

  def self.find_by_param(value)
    first(:conditions => {:nid =>value}) if value != nil
  end

  def to_param
    self.nid.to_s
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

  def on_view
    self.hits += 1
    save
  end

  def on_edit
    self.edited_at = Time.now
  end

  def on_reply
    self.replied_at = Time.now
    save
  end

end
