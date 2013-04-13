class Admin::AccountsController < Admin::ApplicationController
  def index
    @accounts = Account.page(params[:page]).per(Setting.page_size).created_desc
    add_breadcrumb :index
  end

  def new
    @account = Account.new
    add_breadcrumb :new
  end
  
  def create
    @account = Account.new params[:account]
    if @account.save
      redirect_to admin_accounts_path, :notice => t('messages.accounts.success')
    else
      render :new
    end
    add_breadcrumb :new
  end

  def edit
    @account = Account.find params[:id]
    add_breadcrumb :edit
  end
  
  def update
    @account = Account.find params[:id]
    if @account.update_attributes params[:account]
      redirect_to admin_accounts_path, :notice => t('messages.accounts.success')
    else
      render :edit
    end
    add_breadcrumb :edit
  end

  def search
   add_breadcrumb :index
   add_breadcrumb params[:account][:nickname]
    if params[:account][:nickname].blank?
      redirect_to :admin_accounts, :alert => t("messages.accounts.search_error")
      return
    else
      @accounts = Account.search_name(params[:account][:nickname]).page(params[:page]).per(Setting.page_size)
    end
   render :index
  end

  def destroy
    @account = Account.find params[:id]
    if @account.destroy
      redirect_to admin_accounts_path , notice: t('messages.accounts.success')
    else
      redirect_to admin_accounts_path , alert: t('messages.accounts.error')
    end
  end
end