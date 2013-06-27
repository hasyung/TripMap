require 'app/common'

class Map < ActiveRecord::Base
  include SerialNumber::Generate
  include App::Model
  include App::Common

  attr_accessor :slug
  
  #White list
  attr_accessible :province, :province_id, :name, :slug, :version,
                  :map_description_attributes, :map_cover_attributes, :map_plat_attributes, :map_weather_bg_image_attributes

  # Associations
  belongs_to :province, :counter_cache => true
  belongs_to :active_map

  with_options :dependent => :destroy do |assoc|
    assoc.has_many :scenics, :autosave => true
    assoc.has_many :places, :autosave => true
    assoc.has_many :recommends, :autosave => true
    assoc.has_many :shares, :autosave => true
    assoc.has_many :info_lists, :autosave => true
    assoc.has_many :logs
    assoc.has_many :surround_cities
    assoc.has_many :panel_videos
    assoc.has_many :broadcasts
    assoc.has_many :specials
    assoc.has_many :audio_list_categories
    assoc.has_many :first_knowns
  end

  with_options :as => :imageable, :class_name => 'Image', :dependent => :destroy do |assoc|
    assoc.has_one  :map_cover,            :conditions => { :image_type => Image.map_cover   }
    assoc.has_one  :map_plat,             :conditions => { :image_type => Image.map_plat    }
    assoc.has_one  :map_weather_bg_image, :conditions => { :image_type => Image.map_weather_bg_image }
    assoc.has_many :map_slides,           :conditions => { :image_type => Image.map_slides  }
  end

  with_options :as => :textable, :class_name => "Letter", :dependent => :destroy do |assoc|
    assoc.has_one :map_description,       :conditions => { :text_type => Letter.map_description }
  end

  with_options :as => :keywordable, :class_name => "Keyword", :dependent => :destroy do |assoc|
    assoc.has_many :map_slugs,              :conditions => { :keyword_type => Keyword.map_slugs }
  end

  has_many :map_serial_numbers

  # Validates
  with_options :presence => true do |column|
    column.validates :province_id
    column.validates :name, :length => { :within => 1..20, :message => I18n.t("errors.type.name") }, :uniqueness => true
  end

  # Nested attributes validates
  accepts_nested_attributes_for :map_cover,            reject_if: lambda { |img| img[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :map_plat,             reject_if: lambda { |img| img[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :map_weather_bg_image, reject_if: lambda { |img| img[:file].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :map_description,      :allow_destroy => true

  # Scopes
  scope :created_desc, order("created_at DESC")

   # Callbacks
  after_destroy :after_destroy

  # Methods

  def get_map_values
    {
      cover:                  get_file_value(self.map_cover,"file",true),
      description:            get_file_value(self.map_description,"body"),
      slides:                 get_map_slides(),
      scenics:                get_scenics(),
      places:                 get_places(),
      recommends:             get_recommends(),
      info_lists:             get_info_lists(),
      panel_videos:           get_panel_videos(),
      broadcasts:             get_broadcasts(),
      specials:               get_specials(),
      audio_list_categories:  get_audio_list_categories(),
      first_known:            get_first_known()
    }
  end
  
  private

  def after_destroy
    Rails.cache.delete("map_#{self.id}")
  end

  def get_map_slides()
    slides = []
    self.map_slides.order_asc.each{ |o| slides << { image: o.file.url} } if self.map_slides.present?
    slides
  end

  def get_places()
    ret = []
    #self.places.each{ |o| places << get_map_place_values(o) } if self.places_count > 0
    self.places.each{|c| ret << o_to_h(c, ['map', 'map_id', 'version'], ['id']) }
    ret
  end

  def get_scenics()
    ret = []
    self.scenics.each{|c| ret << o_to_h(c, ['map', 'map_id', 'version'], ['id']) }
    ret
  end

  def get_recommends()
    recommends = []
    self.recommends.each{ |o| recommends += get_map_recommend_values(o) } if self.recommends_count > 0
    recommends
  end

  def get_recommends_ext()
    ret = []

    self.recommends.each do|c|
      h_c, l_cc = o_to_h(c, ['map', 'map_id', 'version'], nil, {:category_cd => "category"}), []

      c.recommend_records.order_asc.each do |cc|
        h_cc, l_ccc = o_to_h(cc, ['recommend', 'recommend_id']), []

        cc.recommend_detaileds.order_asc.each do |ccc|
          h_cccc, l_cccc = o_to_h(ccc, ['recommend_record_id']), []
          images, videos, audios, texts, infos, image_lists = [], [], [], [], [], []
          all_avi = ccc.videos | ccc.audios | ccc.image_lists | ccc.detailed_images | ccc.detailed_texts | ccc.detailed_infos
          all_avi = all_avi.sort {|a,b| a[:order] <=> b[:order] }

          all_avi.each do |e|
            case e.class.name.to_s
            when I then images << o_to_h(e, ['file_size', 'order'], nil, {:file => "image"})
            when A then audios << o_to_h(e, nil, nil, {:file => "audio"})
            when V then videos << o_to_h(e, nil, nil, {:file => "video"})
            when T
               texts << o_to_h(e) if e.text_type == Letter.detailed_text
               infos << o_to_h(e) if e.text_type == Letter.detailed_info
            when IL
              imglist_img_h, curr_imglist_imgs = o_to_h(e, ['name', 'order']), []
              e.images.each{|il| curr_imglist_imgs << o_to_h(il, ['file_size', 'order'], nil, {:file => "image"}) }
              imglist_img_h[:images] = curr_imglist_imgs; image_lists << imglist_img_h
            end
          end

          h_cccc[:images] = images; h_cccc[:videos]      = videos
          h_cccc[:audios] = audios; h_cccc[:texts]       = texts
          h_cccc[:infos]  = infos;  h_cccc[:image_lists] = image_lists
          l_ccc << h_cccc
        end
        h_cc[:detaileds] = l_ccc; l_cc << h_cc
      end
      h_c[:records] = l_cc; ret << h_c
    end

    ret
  end

  def get_info_lists()
    ret = []
    self.info_lists.order_asc.each do |info_list|
      info_list.info_list_slugs.each do |s|
        r = {
        info_list_slug:       s.slug,
        info_list_is_free:    info_list.is_free.to_s,
        slug_icon:            get_file_value(info_list.infolist_slug_icon, "file", true),
            }
      end
      tmp_infos = []
      info_list.infos.order_asc.each do |o|
        o.info_slugs.each do |s|
          tmp_infos << { name: o.name, slug: s.slug, is_free: o.is_free.to_s, description: get_file_value(o.letter, "body")}
        end
      end
      r["infos"] = tmp_infos
      ret << r
    end
    ret
  end

  def get_map_place_values place
    places = []
    place.place_slugs.each do |s|
      places <<
      {
      id:                     place.id,
      name:                   place.name,
      is_free:                place.is_free.to_s,
      menu_type:              place.menu_type,
      subtitle:               place.subtitle,
      slug:                   s.slug,
      icon:                   get_file_value(place.place_icon, "file", true),
      slug_icon:              get_file_value(place.place_slug_icon, "file", true),
      image:                  get_file_value(place.place_image, "file", true),
      audio:                  get_file_value(place.place_audio, "file", true),
      audio_size:             get_file_value(place.place_audio, "file_size"),
      audio_duration:         get_file_value(place.place_audio, "duration"),
      video:                  get_file_value(place.place_video, "file",true),
      video_size:             get_file_value(place.place_video, "file_size"),
      video_duration:         get_file_value(place.place_video, "duration"),
      description:            get_file_value(place.place_description, "body"),
      slides:                 get_place_slides(place)
      }
    end
    places
  end

  def get_place_slides place
    slides = []
    place.place_slides.order_asc.each{ |o| slides << { image: o.file.url} } if place.place_slides.present?
    slides
  end

  def get_map_scenic_values scenic
    scenics = []
    scenic.scenic_slugs.each do |s|
      scenics <<
      {
      id:                     scenic.id,
      name:                   scenic.name,
      is_free:                scenic.is_free.to_s,
      menu_type:              scenic.menu_type,
      subtitle:               scenic.subtitle,
      slug:                   s.slug,
      icon:                   get_file_value(scenic.scenic_icon, "file", true),
      slug_icon:              get_file_value(scenic.scenic_slug_icon, "file", true),
      image:                  get_file_value(scenic.scenic_image, "file", true),
      impression:             get_file_value(scenic.scenic_impression, "file", true),
      impression_size:        get_file_value(scenic.scenic_impression, "file_size"),
      impression_duration:    get_file_value(scenic.scenic_impression, "duration"),
      route:                  get_file_value(scenic.scenic_route, "file", true),
      route_size:             get_file_value(scenic.scenic_route, "file_size"),
      route_duration:         get_file_value(scenic.scenic_route, "duration"),
      description:            get_file_value(scenic.scenic_description, "body"),
      slides:                 get_scenic_slides(scenic)
      }
    end
    scenics
  end

  def get_scenic_slides scenic
    slides = []
    scenic.scenic_slides.order_asc.each{ |o| slides << { image: o.file.url} } if scenic.scenic_slides.present?
    slides
  end

  def get_map_recommend_values recommend
    recommends, records = [], []
    if recommend.recommend_records.present?
      recommend.recommend_records.order_asc.each do |record|
        detaileds ||= []
        if record.recommend_detaileds.present?
          record.recommend_detaileds.order_asc.each do |detailed|
            detail ||= []
            if recommend.category_cd == 1
              detail += detailed.videos if detailed.videos.present?
              detail += detailed.audios if detailed.audios.present?
              detail += detailed.image_lists if detailed.image_lists.present?
            end
            if recommend.category_cd != 3
              detail += detailed.detailed_images if detailed.detailed_images.present?
            end
            detail += detailed.detailed_texts if detailed.detailed_texts.present?
            detail += detailed.detailed_infos if detailed.detailed_infos.present?
            detail = detail.sort {|a,b| a[:order] <=> b[:order]}
            content = { :name => detailed.name }
            images ||= []
            videos ||= []
            audios ||= []
            texts  ||= []
            infos ||= []
            image_lists ||= []

            detail.each do |d|
              case d.class.to_s
              when "Image"
                images << {image: d.file.url,  order: d.order}
              when "Video"
                videos << {video: d.file.url,  size: d.file_size, duration: d.duration, cover: d.cover.url,  order: d.order}
              when "Audio"
                audios << {audio: d.file.url,  size: d.file_size, duration: d.duration,  order: d.order}
              when "Letter"
                if d.text_type == 5
                  infos << {url: d.body, order: d.order}
                else
                  texts << {text: d.body, order: d.order}
                end
              when "ImageList"
                imgs ||= []
                d.images.order_asc.each{ |o| imgs << { image: o.file.url }}
                image_lists << {images: imgs,  order: d.order}
              end
            end
            if recommend.category_cd != 3
              content.merge!({images: images}) 
            end
            if recommend.category_cd == 1
              content.merge!({videos: videos})
              content.merge!({audios: audios})
              content.merge!({image_lists: image_lists}) 
            end
            content.merge!({texts: texts})
            content.merge!({infos: infos})
            if recommend.category_cd == 2
              content.merge!({cover: get_file_value(detailed.recommend_detailed_cover,"file",true)})
            end
            detaileds << content
          end
        end
        records << { name: record.name, description: get_file_value(record.recommend_record_description,"body", false), cover: get_file_value(record.recommend_record_cover,"file", true), detaileds: detaileds }
      end
    end
    recommend.recommend_slugs.each do |s|
      recommends <<
      {
      name:                   recommend.name,
      slug:                   s.slug,
      is_free:                recommend.is_free.to_s,
      menu_type:              recommend.menu_type,
      category:               recommend.category_cd,
      slug_icon:              get_file_value(recommend.recommend_slug_icon, "file", true),
      video:                  get_file_value(recommend.recommend_video,"file",true),
      video_size:             get_file_value(recommend.recommend_video,"file_size",false),
      video_duration:         get_file_value(recommend.recommend_video,"duration",false),
      video_cover:            get_file_value(recommend.recommend_video,"cover",true),
      cover:                  get_file_value(recommend.recommend_cover,"file",true),
      records:                records
      }
    end
    recommends
  end

  def get_panel_videos
    ret = []
    self.panel_videos.each do |panel|
      panel.panel_video_slugs.each do |s|
        ret << {
          name: panel.name,
          video: get_file_value(panel,"video",true),
          slug: s.slug,
          slug_cover: get_file_value(panel.panel_video_slug_cover,"file",true)
        }
      end
    end
    ret
  end

  def get_broadcasts
    ret = []
    self.broadcasts.each do |b|
      childrens = []
      b.children_broadcasts.order_asc.each do |c|
        childrens << {
          name: c.name,
          cover: get_file_value(c.children_broadcast_cover,"file",true),
          audio_size: get_file_value(c.children_broadcast_audio,"file_size",false),
          audio_duration: get_file_value(c.children_broadcast_audio,"duration",false),
          audio: get_file_value(c.children_broadcast_audio,"file",true),
          desc: get_file_value(c.children_broadcast_desc, "body")
        }
      end
      b.broadcast_slugs.each do |s|
        ret << {
          name: b.name,
          slug: s.slug,
          slug_cover: get_file_value(c.broadcast_slug_cover,"file",true),
          children_broadcasts: childrens
        }
      end
    end

    ret
  end

  def get_specials
    specials ||= []

    self.specials.each do |s|
      minorities ||= []
      s.minorities.order_asc.each do |m|
        slides, feels = [], []
        m.minority_slides.order_asc.each do |ms|
          slides << {
            image:       get_file_value(ms.minority_slide_icon, "file", true),
            description: get_file_value(ms.minority_slide_description,"body")
          }
        end
        m.minority_feels.order_asc.each do |mf|
          sl ||= []
          mf.minority_feel_slides.order_asc.each{ |o| sl << { image: o.file.url} }
          feels << {
            name:        mf.name,
            image:       get_file_value(mf.minority_feel_icon, "file", true),
            description: get_file_value(mf.minority_feel_description,"body"),
            slides:      sl
          }
        end
        m.minority_slugs.each do |slug|
          minorities << {
          name:           m.name,
          slug:           slug.slug,
          slug_icon:      get_file_value(m.minority_slug_icon, "file", true),
          is_free:        m.is_free.to_s,
          menu_type:      m.menu_type,
          image:          get_file_value(m.minority_icon, "file", true),
          video:          get_file_value(m.minority_video, "file", true),
          video_size:     get_file_value(m.minority_video,"file_size"),
          video_duration: get_file_value(m.minority_video,"duration"),
          video_cover:    get_file_value(m.minority_video,"cover",true),
          description:    get_file_value(m.minority_description,"body"),
          slides:         slides,
          feels:          feels
                        }
        end
        
      end
      s.special_slugs.each do |slug|
        specials << { 
        name:             s.name, 
        slug:             slug.slug,
        slug_icon:        get_file_value(s.special_slug_icon, "file", true),
        is_free:          s.is_free.to_s,
        menu_type:        s.menu_type,
        image:            get_file_value(s.special_icon, "file", true),
        minorities:       minorities
                    }
      end
      
    end
    specials
  end

  def get_audio_list_categories
    ret = []

    self.audio_list_categories.each do|c|
      h_c, l_cc = o_to_h(c, ['map_id', 'version'], nil, {:slug_cover => "slug_icon"}), []

      c.audio_lists.order_asc.each do |cc|
        h_cc, l_ccc = o_to_h(cc, ['audio_list_category_id']), []
        cc.audio_list_items.order_asc.each{|ccc| l_ccc << o_to_h(ccc, ['audio_list_id']) }
        h_cc[:audio_list_items] = l_ccc; l_cc << h_cc
      end

      h_c[:audio_lists] = l_cc; ret << h_c
    end

    ret
  end

  def get_first_known
    knowns = []
    self.first_knowns.each do |known|
      lists = []
      known.first_known_lists.order_asc.each do |list|
        items = []
        list.first_known_list_items.order_asc.each do |item|
          items << {
            title: item.title,
            description: item.description,
            icon: get_file_value(item.first_known_list_item_icon, "file", true)
                   }
        end
        lists << {
          title_cn: list.title_cn,
          title_en: list.title_en,
          url: list.url,
          abstract: list.abstract,
          icon: get_file_value(list.first_known_list_icon, "file", true),
          first_known_list_items: items
        }
      end
      known.first_known_slugs.each do |s|
        knowns << {
          name: known.name,
          slug: s.slug,
          slug_cover: get_file_value(known.first_known_slug_cover, "file", true),
          slides: get_first_known_slides(known),
          first_known_lists: lists
        }
      end
    end
    knowns
  end
  
  def get_first_known_slides known
    slides = []
    known.first_known_slides.order_asc.each{ |o| slides << { image: o.file.url} } if known.first_known_slides.present?
    slides
  end

  def get_file_value( file, field, url = false )
    is_file_blank = file.blank? || file.send(field.to_sym).blank?
    is_zero_type = ( field == "file_size" || field == "duration" )

    ( return is_zero_type ? 0 : "" ) if is_file_blank

    result = url ? file.send(field.to_sym).url : file.send(field.to_sym)
  end

end