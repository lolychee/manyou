class UserBookmark
  include Mongoid::Document
  include Mongoid::Timestamps

  field :rating,        :type => Integer
  field :desc,          :type => String
  field :type,          :type => String

  embedded_in :user

end
