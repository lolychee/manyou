class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Manyou::Authentication

  field :avatar
  mount_uploader :avatar, AvatarUploader

  field :name,                      :type => String
  field :email,                     :type => String
  field :intro,                     :type => String
  field :locale,                    :type => String

  attr_accessible           :avatar, :name, :email, :intro, :locale

  validates_presence_of     :email
  validates_uniqueness_of   :email,     :on => :create
  validates_format_of       :email,     :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, :message => "should be in an email address format (ex: someone@somewhere.com)"
  validates_inclusion_of    :locale,    :in => AppConfig.support_locale, :allow_blank => true

  embeds_one :profile,              :class_name => 'UserProfile'

  #has_and_belongs_to_many :bookmarks
  has_and_belongs_to_many :follow,  :class_name => 'User', :inverse_of => 'follow'

  before_create :build_profile

  has_many :topics, :inverse_of => 'author'

  def to_param
    username
  end

end
