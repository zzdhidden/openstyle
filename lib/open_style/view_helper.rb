module OpenStyle
  module ViewHelper

    def filter_params options = {}, update = {}
      options = options.dup
      options.delete :sort
      options.delete :page
      options.delete :action
      options.delete :controller
      options.update update
      options
    end

    def redirect_tag url = nil
      hidden_field_tag "redirect_to", (url || params[:redirect_to]) #url_for(params)
    end

    def pipe_tag content = " · "
      content_tag(:span, content, :class => "pipe")
    end

    def redirect_object
      { :redirect_to => url_for(params) }
    end

    # Notice message
    # <tt>type</tt> :info, :success, :error
    #
    # Examples
    #
    #   notice_tag :info, "Notice message"
    #
    #   output:
    #
    #   <div class="notice notice-info">Notice message</div>
    #

    def notice_tag type = :info, content_or_options = nil, options = nil, &block
      content_tag_with_default_class(:div, "notice notice-" + type.to_s, content_or_options, options, &block)
    end

    def extlink_to text, url, options = {}
      add_class_to_options "extlink", options
      options[:target] = "_blank"
      link_to text, url, options
    end

    def inlink_to *args
      raw("[#{(link_to *args)}]")
    end

    def sort_link_to name, content, url
      sort = url[:sort]
      url = url.dup
      url.delete :page
      if sort.blank? || sort[0] != 45 
        old_sort_dir = ""
      else
        sort = sort.slice(1,(sort.size-1))
        old_sort_dir = "-"
      end        
      sort_direction_indicator = ''
      sort_dir =''
      if name.to_s == sort
        sort_dir = old_sort_dir == '-' ? '' : '-'
        sort_direction_indicator = icon_tag(sort_dir == "-" ? "desc" : "asc")
      end
      link_to(content_tag(:span, content) + sort_direction_indicator, url.update(:sort => sort_dir + name))
    end

    def link_button_to(*args)
      name         = args.first
      options      = args.second || {}
      html_options = args.third
      url = url_for(options)
      if html_options
        html_options = html_options.stringify_keys
        convert_options_to_javascript!(html_options, url)
      else
        html_options = {}
      end
      html_options["onclick"] ||=  "javascript:document.location.href='#{url}'; return false;"
      html_options.merge!("type" => "button", "value" => name)
      tag("input", html_options)
    end

    def td_tag content = nil, options = nil, &block
      content = block_given? ? capture(&block) : content
      content = raw("&nbsp;") if content.blank? 
      content_tag :td, content, options
    end

    def th_tag content = nil, options = nil, &block
      content = block_given? ? capture(&block) : content
      content = raw("&nbsp;") if content.blank? 
      content_tag :th, content, options, &block
    end

    def truncate_tag text, length = 30, omission = "..."
      text ||= ""
      if text.size > length
        text = content_tag(:span, truncate(text, :length => length, :omission => omission), :title => text)
      end
      text
    end

    #def tabs_tag options, selected = nil, html_options = {}
    #  add_class_to_options 'tabs ul clearfix', html_options
    #  list = options.collect do |a| 
    #    current = selected == a[0] ? 'current' : nil 
    #    right = a[3] ? nil : 'left'
    #    class_name = "#{current} #{right}".strip
    #    class_name = nil if class_name.blank?
    #    content_tag(:li, link_to(a[1], a[2]), :class => class_name) 
    #  end
    #  content_tag 'ul', raw(list.join("")), html_options
    #end

    #def navigation_item_tag id, title, url, html_options = {}
    #  add_class_to_options(current_tab?(id, :navigation) ? 'current' : nil, html_options)
    #  html_options[:id] = id
    #  content_tag('li', link_to(icon_tag(id) + title, url), html_options)
    #end

    #def menu_item_tag id, title, url, html_options = {}, &block
    #  raise ArgumentError, "Missing block" unless block_given?
    #  if current_tab?(id, :menu) 
    #    class_name =  'item current' + (html_options[:class].blank? ? "" : " current-" + html_options[:class].strip.gsub(/\s+/,"-") )
    #  else
    #    class_name =  'item'
    #  end
    #  add_class_to_options(class_name, html_options)
    #  html_options[:id] = id
    #  #content_tag('span', id.humanize)
    #  content_tag('li', content_tag('h4', link_to(icon_tag(id) + title, url)) + capture(&block) , html_options) 
    #end

    #def submenu_item_tag id, title, url, html_options = {}
    #  add_class_to_options(current_tab?(id, :submenu) ? 'sub-current' : nil, html_options)
    #  html_options[:id] = id
    #  content_tag('li', link_to(icon_tag('submenu') + title, url), html_options)
    #end

    def icon_tag class_name, options = {}
      options[:class] = 'icon icon-' + class_name
      content_tag(:em, options[:title], options)
    end

    def page_summary_tag object, options = {}
      #http://gitrdoc.com/rdoc/mislav/will_paginate/b3b0f593ea9b1da13a64bc825dfe17b6bbc2828b/classes/WillPaginate/Collection.html
      #<div class="summary">显示<%=@hosts.total_entries %>个中的<%=@hosts.size %>个</div>
      content_tag(:div, I18n.l("page_summary", {:total => object.total_entries, :size => object.size}), :class => "summary")
    end

    def dl_tag title, content_or_options = nil, options = nil, &block
      content_tag("dl", content_tag("dt", title) + content_tag("dd", ( block_given? ? nil : content_or_options), &block), options)
    end

    def form_help_tag text, error = nil
      text.blank? && error.blank? ? "" : content_tag(:span, (error.blank? ? text : error), :class => (error.blank? ? "form-help" : "form-error"))
    end

    def button_wrap_tag content, options = {}
      wrap_tag("button", content, options)
    end

    def text_wrap_tag content, options = {}
      wrap_tag("text", content, options)
    end

    def board_tag content_or_options = nil, options =nil, &block
      board_t = content_tag("div", content_tag("div", " ", :class => "board-tr") + content_tag("div", " ", :class => "board-tl"), :class => "board-t clearfix")
      board_b = content_tag("div", content_tag("div", " ", :class => "board-br") + content_tag("div", " ", :class => "board-bl"), :class => "board-b clearfix")
      default_class_name = "board"
      if block_given?
        options = content_or_options if content_or_options.is_a?(Hash)
        content_or_options = capture(&block)
      end
      options = add_class_to_options(default_class_name, options)
      content_tag("div", board_t + content_or_options + board_b, options)
    end    

    def board_header_tag content_or_options = nil,options =nil,&block
      content_tag_with_default_class "h4","board-header clearfix", content_or_options, options, &block
    end

    def board_content_tag content_or_options = nil,options =nil,&block
      content_tag_with_default_class "div", "board-content", content_or_options, options, &block    
    end

    def columns_tag content_or_options = nil, options =nil, &block
      content_tag_with_default_class "div", "columns clearfix", content_or_options, options, &block
    end

    def column_tag content_or_options = nil, options =nil, &block
      content_tag_with_default_class "div", "column", content_tag(:div, content_or_options, {:class => "column-inner"}, &block), (options.is_a?(Hash) ? options : content_or_options)
    end

    def add_class_to_options class_name, options = nil
      if class_name
        options ||= {}
        options[:class] = options[:class] ? (options[:class] + " " + class_name) : class_name
      end
      options
    end

    def content_tag_with_default_class tag, default_class_name, content_or_options = nil, options = nil, &block
      if block_given? and content_or_options.is_a?(Hash)
        content_or_options = add_class_to_options(default_class_name, content_or_options)
      else
        options = add_class_to_options(default_class_name, options)
      end
      content_tag(tag, content_or_options, options, &block)
    end

    def content_tag_with_default_options tag, default_options, content_or_options = nil, options = nil, &block
      if block_given? and content_or_options.is_a?(Hash)
        content_or_options = {}.merge(default_options).merge(content_or_options)
      else
        options ||= {}
        options = {}.merge(default_options).merge(options)
      end
      content_tag(tag, content_or_options, options, &block)
    end

    def wrap_tag type, content, options = {}
      options = options.stringify_keys
      disabled = (options["disabled"].eql? "disabled" or options["disabled"] === true)
      hl = options["hl"]
      content_tag(:span, content, :class => "#{type}-wrap" + (disabled ? " button-disabled" : "") + (hl ? " #{type}-hl" : ""))
    end

  end
end
