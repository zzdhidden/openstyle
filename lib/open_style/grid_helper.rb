module OpenStyle
  module GridHelper

    def self.included(base)
      base.class_eval do
        helper        HelperMethods
      end
    end
    module HelperMethods
      def grid_tag(options = {}, &block)
        GridBuilder.new(self, options).render(&block)
      end
    end
  end
end
