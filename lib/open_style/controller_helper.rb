module OpenStyle
  module ControllerHelper

    def self.included(base)
      base.class_eval do
        include InstanceMethods
        alias_method_chain :redirect_to, :param
        attr_accessor :title
      end
    end

    module InstanceMethods
      def redirect_to_with_param options = {}, response_status = {}
        options = params[:redirect_to] unless params[:redirect_to].blank?
        redirect_to_without_param options, response_status
      end

      private

      def parse_sort sort
        return {:name =>nil,:direction =>nil } if(sort.nil? || sort.empty?)
        if sort[0]!=45
          direction = "ASC"
        else
          direction = "DESC"
          sort = sort.gsub(/^\-/,"")
        end
        {:name => sort,:direction => direction }
      end

      def order_option options = {}, table_name = ""    
        sort = parse_sort params[:sort]
        table_name = (table_name.nil? || table_name.empty?) ? "" : table_name + "."
        unless sort[:name].nil?
          options.update(:order => "#{table_name}#{sort[:name]} #{sort[:direction]}")
        else
          options.update(:order => "#{table_name}id DESC")
        end
        options
      end
    end
  end
end
