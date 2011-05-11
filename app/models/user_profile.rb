class UserProfile
  include Mongoid::Document

  embedded_in :user
end
