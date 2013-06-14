class Admin::ApplicationController < ApplicationController

  before_filter :authenticate_user!
  add_breadcrumb :root, :admin_root_path

end