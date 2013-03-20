class V1::MapsController < V1::ApplicationController
    
    def index
    		result = []
    		Map.all.each do |map|			
    		  result << {:id => map.id,
                                   :name => map.name,
                                   :slug => map.slug,
                                   :cover => get_file_value(map.map_cover,"file",true),
                                   :description => get_file_value(map.map_description,"body",false),
                                   :scenics_count => map.scenics_count,
                                   :places_count => map.places_count,
                                   :recommends_count => map.recommends_count,
                                   :shares_count => map.shares_count,
                                   :infos_count => map.infos_count
                                 }
    		end
    		render :json => result
  	end

    def show
      @map = Map.find params[:id]
      serial = MapSerialNumber.find{|num| num.code == params[:serial] }
      result= []
      if (serial.present? && serial.map_id == params[:id].to_i && serial.count > 0) || (params[:serial].blank? && params[:map_type] == "free")
        if serial.present?
          serial.count -= 1
          serial.save
          active_entity =  { :device_id => params[:device_id], :map_id => @map.id, :map_serial_number_id => serial.id }
          ActivateMap.create active_entity
        end

        slides, places, scenics, recommends, records, detaileds, infos = [], [], [], [], [], [], []
        if @map.map_slides.present?
          @map.map_slides.order_asc.each do |slide|
            slides << {:image => slide.file.url}
          end
        end
        if @map.places_count > 0
          @map.places.each do |place|
            places << {:id => place.id,
                                   :name => place.name,
                                   :subtitle => place.subtitle,
                                   :slug => place.slug,
                                   :icon => get_file_value(place.place_icon,"file",true),
                                   :image => get_file_value(place.place_image,"file",true),
                                   :audio => get_file_value(place.place_audio,"file",true),
                                   :audio_size => get_file_value(place.place_audio,"file_size",false),
                                   :audio_duration => get_file_value(place.place_audio,"duration",false),
                                   :video => get_file_value(place.place_video,"file",true),
                                   :video_size => get_file_value(place.place_video,"file_size",false),
                                   :video_duration =>get_file_value(place.place_video,"duration",false),
                                   :description => get_file_value(place.place_description,"body",false)
                                 }
          end
        end
        if @map.scenics_count > 0
          @map.scenics.each do |scenic|
            scenics << {:id => scenic.id,
                                   :name => scenic.name,
                                   :subtitle => scenic.subtitle,
                                   :slug => scenic.slug,
                                   :icon => get_file_value(scenic.scenic_icon,"file",true),
                                   :image => get_file_value(scenic.scenic_image,"file",true),
                                   :impression => get_file_value(scenic.scenic_impression,"file",true),
                                   :impression_size => get_file_value(scenic.scenic_impression,"file_size",false),
                                   :impression_duration =>get_file_value(scenic.scenic_impression,"duration",false),
                                   :route => get_file_value(scenic.scenic_route,"file",true),
                                   :route_size => get_file_value(scenic.scenic_route,"file_size",false),
                                   :route_duration =>get_file_value(scenic.scenic_route,"duration",false),
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
                    images, videos,  audios, texts, image_lists= [], [], [], [], []
                    detail.each do |d|
                      case d.class.to_s
                      when "Image"
                        images << { :image=> d.file.url,  :order => d.order}
                      when "Video"
                        videos << { :video => d.file.url,  :size => d.file_size, :duration => d.duration, :cover => d.cover.url,  :order => d.order}
                      when "Audio"
                        audios << { :audio => d.file.url,  :size => d.file_size, :duration => d.duration,  :order => d.order}
                      when "Letter"
                         texts << { :text => d.body, :order => d.order}
                      when "ImageList"
                        imgs = []
                        d.images.order_asc.each do |img|
                          imgs << {:image => img.file.url}
                        end
                        image_lists << {:images => imgs,  :order => d.order}
                      end
                    end
                    content.merge!({ :images => images}) if images.present?
                    content.merge!({ :videos => videos}) if videos.present?
                    content.merge!({ :audios => audios}) if audios.present?
                    content.merge!({ :texts => texts}) if texts.present?
                    content.merge!({ :image_lists => image_lists}) if image_lists.present?
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
        result << { :cover => get_file_value(@map.map_cover,"file",true),
                                :description => get_file_value(@map.map_description,"body",false),
                                :slides => slides,
                                :scenics => scenics,
                                :places => places,
                                :recommends => recommends,
                                :infos => infos
                              }

    end
        render :json => result
  end
end
