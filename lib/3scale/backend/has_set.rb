module ThreeScale
  module Backend
    module HasSet
      def self.included(base)
        base.extend(ClassMethods)
      end

      private

      def set_items(name)
        storage.smembers(storage_key(name))
      end

      def create_set_item(name, value)
        storage.sadd(storage_key(name), value)
        value
      end
      
      def delete_set_item(name, value)
        storage.srem(storage_key(name), value)
      end

      def has_set_items?(name)
        storage.scard(storage_key(name)).to_i > 0
      end
      
      def has_set_item?(name, value)
        storage.sismember(storage_key(name), value)
      end

      module ClassMethods
        def has_set(name)
          plural   = name.to_sym
          singular = name.to_s.sub(/s$/, '').to_sym

          define_method(plural)               { set_items(name) }
          define_method("create_#{singular}") { |value| create_set_item(name, value) }
          define_method("delete_#{singular}") { |value| delete_set_item(name, value) }
          define_method("has_#{plural}?")     { has_set_items?(name) }
          define_method("has_no_#{plural}?")  { !has_set_items?(name) }
          define_method("has_#{singular}?")   { |value| has_set_item?(name, value) }
        end
      end
    end
  end
end