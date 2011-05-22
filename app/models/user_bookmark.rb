class UserBookmark
  include Mongoid::Document
  include Mongoid::Timestamps

  field :rating,        :type => Integer
  field :desc,          :type => String
  field :collection,    :type => String

  embedded_in :user

end
