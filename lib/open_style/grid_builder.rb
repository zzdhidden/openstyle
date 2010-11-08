module OpenStyle
  class GridBuilder

    def initialize(context, options = {})
      @context = context
      options ||= {}
      options.stringify_keys!
      @options = {:cellspacing => 0}.merge(options)
      @col_num = 0
      @odd = false
    end

    def r options = nil, &block
      class_name = (@odd ? "odd" : "even") + (@not_first ? "" : " first")
      @not_first = true
      @odd = !@odd
      @context.content_tag_with_default_class(:tr, class_name, @context.td_tag("", :class => "first") + @context.capture(&block) + @context.td_tag("", :class => "last"), options)
    end

    def h *args, &block
      @col_num += 1
      @context.th_tag(*args, &block)
    end

    def d *args, &block
      @context.td_tag(*args, &block)
    end

    def head options = nil, &block
      content_tag :thead, content_tag(:tr, @context.th_tag("", :class => "first") + @context.capture(&block) + @context.th_tag("", :class => "last")), options
    end

    def body *args, &block
      content_tag :tbody, *args, &block
    end

    def foot *args, &block
      content_tag :tfoot, content_tag(:tr, @context.th_tag("", :class => "first") + @context.content_tag_with_default_options(:th , {:colspan => @col_num}, *args, &block) + @context.th_tag("", :class => "last"))
    end

    def render(&block)
      raise LocalJumpError, "no block given" unless block_given?
      @context.content_tag_with_default_class :table, "grid", @context.capture(self, &block), @options
    end

    private

    def content_tag *args, &block
      @context.content_tag *args, &block
    end
  end
end

