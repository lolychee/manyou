module Manyou::AutoIncrement

  extend ActiveSupport::Concern

  included do
    def self.ai_field(column, default = 1)

      field column, :type => Integer if !method_defined? column

      set_callback :create, :before do |object|
        auto_increment_id column, default
      end
    end

  end

  private

  def auto_increment_id(column, default = 1)
    db = Mongoid.master
    collection = db.collection "auto_increment"
    collection_name = self.class.name.downcase.pluralize

    info = collection.find_and_modify({:query => {:id => collection_name}, :update => {"$inc" => {:value => 1}}, :new => true})
    write_attribute column, info[:value]

  rescue Mongo::OperationFailure
    collection.save({:id => collection_name, :value => default})
    write_attribute column, default
  end

end
