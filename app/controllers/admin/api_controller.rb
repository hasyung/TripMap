class Admin::ApiController < Admin::ApplicationController

  def v1
    @api_cnt = 0
    set_page_tags(t("admin.apis.v1"))
  end

end