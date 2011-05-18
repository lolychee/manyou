class TopicMedium
  include Mongoid::Document

  field :name,              :type => String
  field :url,               :type => String
  field :file
  field :content_type,      :type => String
  field :content_subtype,   :type => String
  field :desc,              :type => String
  field :sort,              :type => Integer
  field :extra,             :type => Hash

  embedded_in :topic
end
