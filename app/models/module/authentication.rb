module Manyou::Authentication

  extend ActiveSupport::Concern

  included do

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
    validates_confirmation_of :password, :unless => Proc.new {|user| user.password.blank?}
    validates_length_of       :password, :minimum => 6, :maximum => 20, :unless => Proc.new {|user| user.password.blank?}

    before_save :prepare_password

    def self.find_by_username(username)
      first(:conditions => {:username => /^#{username}$/i})
    end

    def self.authenticate(login, password)
      user = first(:conditions => {:username => /^#{login}$/i}) || first(:conditions => {:email => /^#{login}$/i})
      return user if user && user.valid_password?(password)
    end

    def self.hex_token
      self.class.secure_digest(Time.now, (1..10).map{ rand.to_s })
    end

    def self.secure_digest(*args)
      Digest::SHA1.hexdigest(args.flatten.join('--'))
    end

  end

  def valid_password?(password)
    crypted_password == encrypt_password(password)
  end

  def reset_persistence_token!
    write_attribute :persistence_token, self.class.hex_token
    save
  end

  def clear_persistence_token!
    write_attribute :persistence_token, nil
    save
  end

  def encrypt_password(password)
    self.class.secure_digest([password, password_salt])
  end

  def prepare_password
    unless password.blank?
      write_attribute :password_salt, self.class.secure_digest([Time.now, rand])
      write_attribute :crypted_password, encrypt_password(password)
    end
  end


end
