module Manyou::Vote

  extend ActiveSupport::Concern

  included do

    field :vote_up,      :type => Integer,   :default => 0 if !method_defined? :vote_up
    field :vote_down,    :type => Integer,   :default => 0 if !method_defined? :vote_down

    has_and_belongs_to_many :vote_user,    :class_name => 'User' if !method_defined? :vote_user

  end

end
