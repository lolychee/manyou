class Profile
  include Mongoid::Document

  embedded_in :user

  field :homepage,              :type => String
end
