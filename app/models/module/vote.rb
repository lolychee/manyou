module Manyou::DB
  module Manyou::DB::Vote

    extend ActiveSupport::Concern

    included do

      field :vote_up,      :type => Integer,   :default => 0
      field :vote_down,    :type => Integer,   :default => 0

      #has_and_belongs_to_many :vote_users, :class_name => 'User'
      has_many :vote_users, :class_name => 'User'

      class_eval do
        def vote!(user, type = 1)
          if !is_vote?(user)
            vote_user_ids << user._id
            if type > 0
              write_attribute :vote_up, vote_up+1
            else
              write_attribute :vote_down, vote_down+1
            end
            save
          end
        end

        def is_vote?(user)
          vote_user_ids.include?(user._id)
        end
      end
    end

  end
end
