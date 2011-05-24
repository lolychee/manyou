class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  include Manyou::DB::Vote
  include Manyou::DB::AutoIncrement

  ai_field :short_id

  field :thumbnail
  #mount_uploader :thumbnail, TopicThumbnailUploader

  field :title,                 :type => String
  field :content,               :type => String
  field :hits,                  :type => Integer,   :default => 0
  field :status,                :type => String,    :default => 'normal'
  #field :type,                  :type => Array,     :default => []
  field :tag,                   :type => String

  STATUS    = ['normal', 'ban']
  #TYPE      = ['tweet', 'article', 'media']

  attr_accessible :title, :content, :tag


  field :bookmarks,             :type => Integer,   :default => 0

  field :edited_at,             :type => Time,      :default => Time.now
  field :replied_at,            :type => Time,      :default => Time.now

  belongs_to :author,           :class_name => 'User', :inverse_of => 'topics'

  embeds_many :replies,         :class_name => 'TopicReply'
  embeds_many :media,           :class_name => 'TopicMedium'
  field :media_type,            :type => Array,     :default => []

  has_and_belongs_to_many :track_users, :class_name => 'User'
  has_and_belongs_to_many :nodes, :class_name => 'Node'

  #has_and_belongs_to_many :meta_tags, :class_name => 'Tag'


  scope :find_by_author,    ->(id)  { where(:author_id => id) }
  scope :find_by_nodes,      ->(nodes){ where(:node_ids.in => nodes ) }

  #validates_inclusion_of    :type,      :in => TYPE, :allow_blank => true
  validates_inclusion_of    :status,    :in => STATUS, :allow_blank => true

  before_save do
    nodes.concat Node.find_or_create_nodes(tag) if !tag.blank?
  end

  def to_param
    short_id.to_i.to_s
  end

  def self.nodes_could
    map = <<EOF
function() {
    var date=new Date();
    date.setDate(date.getDate()-30);

    if (!this.node_ids && this.created_at < date) {
        return;
    }

    for (index in this.node_ids) {
        emit(this.node_ids[index], 1);
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
    collection.mapreduce(map, reduce, {:out => 'nodes_could'}).find({}, :sort => [:value, :desc]).collect{|node| Node.find node['_id'] }.delete_if{|node| node.nil?}
    rescue Mongo::OperationFailure
      []
  end

end
