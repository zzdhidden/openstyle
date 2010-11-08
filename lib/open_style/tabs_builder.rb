module OpenStyle
  class TabsBuilder

    def initialize(context, options = {})
      @context = context
      options ||= {}
      options.stringify_keys!
      @namespace = options.delete("namespace").to_s
      @options = options
    end

    # Returns a link_to +tab+ with +name+ and +options+ if +tab+ is not the current tab,
    # a simple tab name wrapped by a span tag otherwise.
    # 
    #   current_tab? :foo   # => true
    # 
    #   item :foo, 'Foo', foo_path
    #   # => "<li class="current"><span>Foo</span></li>"
    # 
    #   item :bar, 'Bar', bar_path
    #   # => "<li><a href="/link/to/bar">Bar</a></li>"
    # 
    # You can pass a hash of <tt>item_options</tt>
    # to customize the behavior and the style of the li element.
    #
    #   # Pass a custom class to the element
    #   item :bar, 'Bar', bar_path, :class => "custom"
    #   # => "<li class="custom"><a href="/link/to/bar">Bar</a></li>"
    #
    #
    def item(tab, content_or_options = nil, options = nil, &block)
      class_name = @namespace + "-item"
      class_name << " " + @namespace + "-current" if  @context.current_tab?(tab, @namespace)
      @context.content_tag_with_default_class :li, class_name, content_or_options, options, &block    
    end

    def method_missing(*args, &block)
      item(*args, &block)
    end

    def render(&block)
      raise LocalJumpError, "no block given" unless block_given?
      @context.content_tag_with_default_class :ul, (@namespace + " clearfix"), @context.capture(self, &block), @options
    end

  end
end

