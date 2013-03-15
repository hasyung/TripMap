class V1::SharesController < V1::ApplicationController

	def current
		result = []
		@map = Map.find params[:map_id]
		size = params[:page_size].to_i
		index = params[:page_index].to_i
		first = (index-1)*size+1
		last = index*size
		@shares = @map.shares.values_at(first..last)
		if !@shares.blank?
			@shares.each do |share|
				result << {id: share.id,
								 title: share.title,
								  ip: share.ip,
								  image: share.share_image.file.url,
								  cover: share.share_image.file.thumbnail.url,
								  text: share.share_text.body
								  }
			end
		end
		render :json => result
	end

	def nearby
		result = []
		@shares = Share.all.reject {|lambda| lambda.map_id == params[:map_id].to_i}
		size = params[:page_size].to_i
		index = params[:page_index].to_i
		first = (index-1)*size+1
		last = index*size
		if !@shares.blank?
			if !@shares.values_at(first..last).blank?
				@shares.values_at(first..last).each do |share|
					result << {id: share.id,
									 title: share.title,
									  ip: share.ip,
									  image: share.share_image.file.url,
									  cover: share.share_image.file.thumbnail.url,
									  text: share.share_text.body
									  }
				end
			end
		end
		render :json => result
	end

	def create
		@share = Share.new params[:share]
		if @scenic.save
      		result = true
    		else
      		result = false
    		end
    		render :json => result
	end

end