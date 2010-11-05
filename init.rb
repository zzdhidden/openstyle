# Include hook code here
#

require 'openstyle'
ActionView::Base.send(:include, OpenStyle::ViewHelper)
ActionController::Base.send(:include, OpenStyle::ControllerHelper)
ActionController::Base.send(:include, OpenStyle::TabsHelper)

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag
end

#OpenStyle::FormBuilder.send(:extend, ActionView::Helpers::FormBuilder)
#ActiveSupport::Deprecation.warn "#{method} was removed from Rails and is now available as a plugin. " "Read https://github.com/mislav/will_paginate/wiki/installation"
