class ApplicationController < ActionController::Base
  protect_from_forgery

  def set_page_tags(title = nil, keywords = nil, description = nil)
    @page_title = "#{title}" if !title.blank?
    @page_keywords = keywords if !keywords.blank?
    @page_description = description if !description.blank?
    add_breadcrumb(title)
  end

  def has_nil_value_in( keys = [] )
    has_nil = false
    keys.each{|k| break if has_nil ||= params[k.to_sym].nil? }
    has_nil
  end

end