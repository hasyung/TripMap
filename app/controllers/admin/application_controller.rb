class Admin::ApplicationController < ApplicationController

  before_filter :authenticate_user!
  add_breadcrumb :root, :admin_root_path
  
  def set_slug(slug, model)
    slugs = slug.split(";")
    model.each{|m| m.destroy}
    slugs.each{|s| model.create slug: s}
  end
end