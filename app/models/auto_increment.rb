module AutoIncrement

  extend ActiveSupport::Concern

  included do
    def self.ai_field(_field, default = 1)
      field _field, :type => Integer
      set_callback :create, :before do |object|
        auto_increment_id(_field, default)
      end
    end

  end

  def auto_increment_id(_field, default)
    db = Mongoid.master
    ai_collection = db.collection("auto_increment")
    current_collection_name = self.class.name.downcase.pluralize
    current_id = ai_collection.find_and_modify({:query => {:_id => current_collection_name},:update => {'$inc' => {:value => 1}}, :new => true})
    eval("self.#{_field} ||= current_id['value']")

    rescue Mongo::OperationFailure
      ai_collection.save({:_id => current_collection_name, :value => default})
      eval("self.#{_field} = #{default}")
  end

end
