class Admin::DeclarationsController < Admin::ApplicationController

  def show
    add_breadcrumb :index

    if request.get?
      @declaration = Declaration.all.blank? ? Declaration.new : Declaration.first
    else
      @declaration = Declaration.all.blank? ? (Declaration.new params[:declaration]) : Declaration.first
      result = Declaration.all.blank? ? @declaration.save : (@declaration.update_attributes params[:declaration])
      result ? (redirect_to admin_declaration_path, :notice => t('messages.declarations.success')) :
               (render :show)
    end
  end

end