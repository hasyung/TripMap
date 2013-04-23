class Admin::RecommendsController < Admin::ApplicationController
	def index
		@recommends = Recommend.includes(:map).page(params[:page]).per(Setting.page_size).created_desc

		add_breadcrumb :index
	end

	def new
		@recommend = Recommend.new

		add_breadcrumb :new
	end

	def create
		@recommend = Recommend.new params[:recommend]
		if @recommend.save
			redirect_to admin_recommends_path, notice: t('messages.recommends.success')
		else 
			render :new
		end
	end

	def edit
		@recommend = Recommend.find params[:id]
	end

	def update
		@recommend = Recommend.find params[:id]
		if @recommend.update_attributes params[:recommend]
			redirect_to admin_recommends_path, notice: t('messages.recommends.success')
		else
			render :edit
		end
	end

	def destroy
		recommend = Recommend.find params[:id]
		if recommend.destroy
			redirect_to admin_recommends_path, notice: t('messages.recommends.success')
		else
			redirect_to admin_recommends_path, notice: t('messages.recommends.error')
		end
	end

end