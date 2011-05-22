module Manyou::DB
  module Manyou::DB::AutoIncrement

    extend ActiveSupport::Concern

    included do
      def self.ai_field(column, default = 1)

        field column, :type => Integer if !method_defined? column

        set_callback :create, :before do |object|
          auto_increment_id(column, default)
        end
      end

    end

    private

    def auto_increment_id(column, default = 1)
      coll = db.collection "auto_increment"

      info = coll.find_and_modify({:query => {:_id => collection_name}, :update => {'$inc' => {:value => 1}}, :new => true})
      write_attribute column, info['value']

    rescue Mongo::OperationFailure
      coll.save({:_id => collection_name, :value => default})
      write_attribute column, default
    end

  end
end
