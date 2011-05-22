class UserProfile
  include Mongoid::Document

  field :homepage,          :type => String

  embedded_in :user
end
