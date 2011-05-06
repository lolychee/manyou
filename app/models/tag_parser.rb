module TagParser

  extend ActiveSupport::Concern

  included do
    field :index_tags,  :type => Array, :default => [] if !self.method_defined? :index_tags

    def self.find_by_tags(tags)
      tags = Tag.find_tags(tags)
      self.all_in(:index_tags => tags.collect{|tag| tag.id})
    end

    def self.tag_field(_field)
      field _field, :type => String

      validates_format_of _field, :with => Tag::TagsRegex

      #define_method("#{_field}="){|value|
      #  write_attribute _field, Tag.string_to_array(value)
      #}
      set_callback :save, :before do |object|
        _tag_was = eval("object.#{_field}_was")
        _tag = eval("object.#{_field}")

        Tag.find_tags(_tag_was).each{|tag| object.index_tags.delete tag.id}
        object.index_tags.concat Tag.find_tags(_tag).collect{|tag| tag.id}
      end
    end

  end

end

