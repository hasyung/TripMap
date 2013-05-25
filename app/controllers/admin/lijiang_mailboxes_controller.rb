class Admin::LijiangMailboxesController < Admin::ApplicationController

  def index
    @entities = LijiangMailbox.page(params[:page]).per(Setting.page_size).created_desc
    add_breadcrumb :index
  end

  def destroy
    @entity = LijiangMailbox.find params[:id]

    if @entity.destroy
      redirect_to admin_lijiang_mailboxes_path, :notice => t('messages.lijiang_mailboxes.success')
    else
      redirect_to admin_lijiang_mailboxes_path, :alert => t('messages.lijiang_mailboxes.error')
    end
  end

end