class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include AutoIncrement

  include Gravtastic
  gravtastic :rating => 'G', :size => 48

  # authorization field
  field :username,                  :type => String
  field :crypted_password,          :type => String
  field :password_salt,             :type => String
  field :persistence_token,         :type => String
  field :single_access_token,       :type => String
  field :perishable_token,          :type => String

  attr_accessor             :password, :password_confirmation, :current_password
  attr_accessible           :username, :password, :password_confirmation, :current_password

  validates_uniqueness_of   :username, :on => :create
  validates_format_of       :username, :with => /^[-\w\._]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_"
  validates_confirmation_of :password, :unless => Proc.new {|user| user.password_required?}
  validates_length_of       :password, :minimum => 6, :maximum => 20, :unless => Proc.new {|user| user.password_required?}
  before_save :prepare_password

  #person field
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

  field :mark_ids,                  :type => Array,     :default => []

  #admin field
  field :admin_role,                :type => String

  embeds_one :profile
  before_create :build_profile

  has_many :topics

  def self.find_by_param(value)
    find_by_username(value)
  end

  def to_param
    self.username
  end

  def self.find_by_username(username)
    first(:conditions => {:username => /^#{username}$/i})
  end

  def mark
    self.mark_ids
  end

  def unmark(object)
    if marked? object
      self.mark_ids.delete(object.id)
      save
    end
  end

  def mark!(object)
    unless marked? object
      self.mark_ids << object.id
      save
    end
  end

  def marked?(object)
    self.mark_ids.include? object.id unless self.mark_ids.nil?
  end


  #authorization methods
  def self.authenticate(login, pass)
    user = first(:conditions => {:username => /^#{login}$/i}) || first(:conditions => {:email => /^#{login}$/i})
    return user if user && user.matching_password?(pass)
  end

  def matching_password?(pass)
    self.crypted_password == encrypt_password(pass)
  end

  def password_required?
    password.blank?
  end

  def persistence_token?
    persistence_token
  end

  def reset_persistence_token!
    self.persistence_token = self.class.hex_token
    save
  end

  def clear_persistence_token!
    self.persistence_token = nil
    save
  end

  def admin_role?(role)
    self.admin_role == role
  end

  def is_guest?
    self.username.nil?
  end

  private

  def self.hex_token
    secure_digest(Time.now, (1..10).map{ rand.to_s })
  end

  def self.secure_digest(*args)
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end

  def encrypt_password(pass)
    self.class.secure_digest([pass, password_salt])
  end

  def prepare_password
    unless password.blank?
      self.password_salt = self.class.secure_digest([Time.now, rand])
      self.crypted_password = encrypt_password(password)
    end
  end

end
