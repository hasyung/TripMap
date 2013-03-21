class V1::SharesController < V1::ApplicationController

	def current
		result = []
		@map = Map.find params[:map_id].to_i
		size = params[:page_size].to_i
		index = params[:page_index].to_i
		first = (index-1)*size
		last = index*size - 1
		@shares = @map.shares
		if !@shares.blank?
			if (@shares.count - 1) > first
				if (@shares.count - 1) >= last
				 	shares = @shares.values_at(first..last)
				 else
				 	shares = @shares.values_at(first..(@shares.count - 1))
				 end 
				shares.each do |share|
					result << {id: share.id,
								 title: share.title,
								  nickname: share.nickname,
								  image: share.share_image.file.url,
								  cover: share.share_image.file.thumbnail.url,
								  text: share.share_text.body
								  }
				end
			elsif (@shares.count - 1) == first
				share = @shares[first]
				result << {id: share.id,
									 title: share.title,
									  nickname: share.nickname,
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
		first = (index-1)*size
		last = index*size - 1
		if !@shares.blank?
			if (@shares.count - 1) > first
				if (@shares.count - 1) >= last
				 	shares = @shares.values_at(first..last)
				 else
				 	shares = @shares.values_at(first..(@shares.count - 1))
				 end 
				shares.each do |share|
					result << {id: share.id,
								 title: share.title,
								  nickname: share.nickname,
								  image: share.share_image.file.url,
								  cover: share.share_image.file.thumbnail.url,
								  text: share.share_text.body
								  }
					end
			elsif (@shares.count - 1) == first
				share = @shares[first]
				result << {id: share.id,
									 title: share.title,
									  nickname: share.nickname,
									  image: share.share_image.file.url,
									  cover: share.share_image.file.thumbnail.url,
									  text: share.share_text.body
									  }
			end
		end
		render :json => result
	end

	def create
		@share = Share.new
		@share.map_id = params[:map_id].to_i
		@share.title = params[:title]
		@share.nickname = params[:nickname]
		@share.build_share_image file: params[:image]
		@share.build_share_text body: params[:text]
		if @share.save
      		result = {result: true}
    		else
      		result = {result: false}
    		end
    		render :json => result
	end
end