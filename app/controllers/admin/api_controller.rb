class Admin::ApiController < Admin::ApplicationController
  
  #before_filter :add_common_breadcrumb
  
  def v1
    set_page_tags(t("admin.pages.api.v1"))
  end
  
  def v2
    set_page_tags(t("admin.pages.api.v2"))
  end
  
end
