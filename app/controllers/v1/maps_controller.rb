class V1::MapsController < V1::ApplicationController
    
    def index
    		result = []
    		Map.all.each do |map|			
    		  result << {:id => map.id,
                                   :name => map.name,
                                   :slug => map.slug,
                                   :cover => get_file_value(map.map_cover,"file",true),
                                   :description => get_file_value(map.map_description,"body",false)
                                 }
    		end
    		render :json => result
  	end

    def show
      @map = Map.find params[:id]
      result, slides, places, scenics, recommends, records, detaileds, infos = [], [], [], [], [], [], [], []
      if @map.map_slides.present?
        @map.map_slides.order_asc.each do |slide|
          slides << {:image => slide.file.url}
        end
      end
      if @map.places_count > 0
        @map.places.each do |place|
          places << {:id => place.id,
                                 :name => place.name,
                                 :slug => place.slug,
                                 :icon => get_file_value(place.place_icon,"file",true),
                                 :image => get_file_value(place.place_image,"file",true),
                                 :audio => get_file_value(place.place_audio,"file",true),
                                 :audio_size => get_file_value(place.place_audio,"file_size",false),
                                 :audio_duration => get_file_value(place.place_audio,"duration",false),
                                 :video => get_file_value(place.place_video,"file",true),
                                 :video_size => get_file_value(place.place_video,"file_size",false),
                                 :video_duration =>get_file_value(place.place_video,"duration",false),
                                 :video_cover => get_file_value(place.place_video,"cover",true),
                                 :description => get_file_value(place.place_description,"body",false)
                               }
        end
      end
      if @map.scenics_count > 0
        @map.scenics.each do |scenic|
          scenics << {:id => scenic.id,
                                 :name => scenic.name,
                                 :slug => scenic.slug,
                                 :icon => get_file_value(scenic.scenic_icon,"file",true),
                                 :image => get_file_value(scenic.scenic_image,"file",true),
                                 :impression => get_file_value(scenic.scenic_impression,"file",true),
                                 :impression_size => get_file_value(scenic.scenic_impression,"file_size",false),
                                 :impression_duration =>get_file_value(scenic.scenic_impression,"duration",false),
                                 :impression_cover => get_file_value(scenic.scenic_impression,"cover",true),
                                 :route => get_file_value(scenic.scenic_route,"file",true),
                                 :route_size => get_file_value(scenic.scenic_route,"file_size",false),
                                 :route_duration =>get_file_value(scenic.scenic_route,"duration",false),
                                 :route_cover => get_file_value(scenic.scenic_route,"cover",true),
                                 :description => get_file_value(scenic.scenic_description,"body",false)
                               }
        end
      end
      if @map.recommends_count > 0
        @map.recommends.each do |recommend|
          if recommend.recommend_records.present?
            recommend.recommend_records.order_asc.each do |record|
              if record.recommend_detaileds.present?
                record.recommend_detaileds.order_asc.each do |detailed|
                  detail = []
                  detail += detailed.images if detailed.images.present?
                  detail += detailed.videos if detailed.videos.present?
                  detail += detailed.audios if detailed.audios.present?
                  detail += detailed.texts if detailed.texts.present?
                  detail += detailed.image_lists if detailed.image_lists.present?
                  detail = detail.sort {|a,b| a[:order] <=> b[:order]}
                  content = {:name => detailed.name}
                  detail.each do |d|
                    case d.class.to_s
                    when "Image"
                      content.merge!({ :image => d.file.url })
                    when "Video"
                      content.merge!({ :video => d.file.url, :video_size => d.file_size, :video_duration => d.duration, :video_cover => d.cover.url })
                    when "Audio"
                      content.merge!({ :audio => d.file.url, :audio_size => d.file_size, :audio_duration => d.duration })
                    when "Text"
                      content.merge!({ :text => d.body })
                    when "ImageList"
                      images = []
                      d.images.group_order_asc.each do |img|
                        images << {:image => img.file.url}
                      end
                      content.merge!({ :images => images })
                    end
                  end
                  detaileds << content
                end
              end
              records << { :name =>record.name,
                                        :cover => get_file_value(record.recommend_record_cover,"file",true),
                                        :detaileds => detaileds
                                      }
            end
          end
          recommends << { :name => recommend.name,
                                            :slug => recommend.slug,
                                            :video => get_file_value(recommend.recommend_video,"file",true),
                                            :video_size => get_file_value(recommend.recommend_video,"file_size",false),
                                            :video_duration =>get_file_value(recommend.recommend_video,"duration",false),
                                            :video_cover => get_file_value(recommend.recommend_video,"cover",true),
                                            :cover => get_file_value(recommend.recommend_cover,"file",true),
                                            :records => records
                                          }
        end
      end
      if @map.infos_count > 0
        @map.infos.order_asc.each do |info|
          infos << {  :name => info.name,
                                 :slug => info.slug,
                                 :description => get_file_value(info.letter,"body",false)
                               }
        end
      end
      result << { :slides => slides,
                              :scenics => scenics,
                              :places => places,
                              :recommends => recommends,
                              :infos => infos
                            }
      render :json => result
    end

  	def validate
  		if MapSerialNumber.all.find{|num| num.map_id ==  params[:map_id].to_i && num.code == params[:serial] &&num.count > 0 }.blank?
  			result = {result: false}
  		else
  			result = {result: true}
  		end
  		render :json => result
  	end	

end
