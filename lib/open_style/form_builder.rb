module OpenStyle
  class FormBuilder < ActionView::Helpers::FormBuilder

    helpers = field_helpers +
      %w{date_select datetime_select time_select} +
      %w{submit collection_select select country_select time_zone_select} -
      %w{hidden_field label fields_for check_box radio_button} # Don't decorate these

    helpers.each do |name|
      define_method(name) do |field, *args|
        options = args.last.is_a?(Hash) ? args.pop : {}
        wrap(name, super, options)
      end
    end

    def item field, content_or_options = nil, options = nil, &block
      options = content_or_options if block_given?
      options ||= {}
      options.stringify_keys!
      options["class"] ||= "clearfix"
      title = label(field, options["label"])
      title << @template.content_tag("em", "*") if options.delete("required")
      @template.dl_tag(title, content_or_options, options, &block)
    end

    def help field, text, error = nil
      @template.form_help_tag( text, error || errors_on(field) )
    end

    def input *args
      field = args.first.to_s
      options = args.last.is_a?(Hash) ? args.last : {}
      options.stringify_keys!
      required = options.delete("required")
      help = options.delete("help")
      error = options.delete("error")
      column_type = column_type_on(field)
      case column_type
      when :string
        content = field.include?("password") ? password_field(*args) : text_field(*args)
      when :text
        content = text_area(*args)
      when :integer, :float, :decimal
        content = number_field(*args)
      when :date
        content = date_select(*args)
      when :datetime, :timestamp
        content = datetime_select(*args)
      when :time
        content = time_select(*args)
      when :boolean
      end
      item(field, content + help(field, help, error), {:required => required})
    end

    private

    #["can't be blank"]
    def errors_on field
      object.respond_to?(:errors) && object.errors[field].join(",")
    end

    def required_on field
    end

    def validators_on field
      object.class.respond_to?(:validators_on) && object.class.validators_on(field)
    end

    def wrap name, content, options
      name = name.to_s
      if name.include?("field") or name.include?("text")
        @template.text_wrap_tag(content, options)
      elsif ['submit', 'button', 'reset'].include?(name)
        @template.button_wrap_tag(content, options)
      else
        content
      end
    end

    def column_type_on field
      object.respond_to?(:column_for_attribute) ? object.send(:column_for_attribute, field).type : :string
    end

  end
end
