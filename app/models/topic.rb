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

  STATUS    = ['normal', 'ban']
  #TYPE      = ['tweet', 'article', 'media']

  attr_accessible :title, :content, :tag

  field :tag

  field :bookmarks,             :type => Integer,   :default => 0

  field :edited_at,             :type => Time,      :default => Time.now
  field :replied_at,            :type => Time,      :default => Time.now

  belongs_to :author,           :class_name => 'User', :inverse_of => 'topics'

  embeds_many :replies,         :class_name => 'TopicReply'
  embeds_many :media,           :class_name => 'TopicMedium'
  field :media_type,            :type => Array,     :default => []

  has_and_belongs_to_many :track_users, :class_name => 'User'
  has_and_belongs_to_many :tags, :class_name => 'Tag'

  has_and_belongs_to_many :meta_tags, :class_name => 'Tag'


  scope :find_by_author,    ->(id)  { where(:author_id => id) }
  scope :find_by_tags,      ->(tags){ where(:tag_ids.in => tags ) }

  #validates_inclusion_of    :type,      :in => TYPE, :allow_blank => true
  validates_inclusion_of    :status,    :in => STATUS, :allow_blank => true

  before_save do
    tags.concat Tag.find_or_create_tags(tag) if !tag.blank?
  end

  def to_param
    short_id.to_i.to_s
  end

end
