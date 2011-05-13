module Manyou::Vote

  extend ActiveSupport::Concern

  included do

    field :vote_up,      :type => Integer,   :default => 0 if !method_defined? :vote_up
    field :vote_down,    :type => Integer,   :default => 0 if !method_defined? :vote_down

    has_and_belongs_to_many :vote_users, :class_name => 'User' if !method_defined? :vote_users

    class_eval do
      def vote_up!(user)
        if !is_vote?(user)
          vote_user.push(user)
          write_attribute :vote_up, vote_up+1
          save
        end
      end

      def vote_down!(user)
        if !is_vote?(user)
          vote_user.push(user)
          write_attribute :vote_down, vote_down+1
          save
        end
      end

      def is_vote?(user)
        vote_user_ids.include?(user._id)
      end
    end

  end

end
