module Neography
  class Rest
    module Paths

      def add_path(key, path)
        method_name = :"#{key}_path"

        metaclass = (class << self; self; end)
        metaclass.instance_eval do
          define_method method_name do |*attributes|
            if attributes.any?
              build_path(path, *attributes)
            else
              path
            end
          end
        end

        define_method method_name do |*attributes|
          self.class.send(method_name, *attributes)
        end
      end

      def build_path(path, attributes)
        path.gsub(/:([\w_]*)/) do
          encode(attributes[$1.to_sym].to_s)
        end
      end

      def encode(value)
        URI.encode(value).gsub("/","%2F")
      end

    end
  end
end
