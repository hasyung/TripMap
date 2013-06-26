class Api::V1::FightsController < Api::V1::ApplicationController

  def index
    result = []
    Fight.all.each do |m|
      result << {
        name:         m.name,
        slug:         m.fight_slug.slug,
        slug_icon:    get_url(m.fight_slug_icon),
        image:        get_url(m.fight_icon)
       }
    end

    render :json => result
  end

  def show
    result = {}
    k = Keyword.find_by_slug params[:id]
    fight = Fight.find_by_id(k.keywordable_id) if k
    if fight.present?
      minorities ||= []
      fight.minorities.order_asc.each do |m|
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
        minorities << {
          name:           m.name,
          slug:           get_file_value(m.minority_slug, "slug"),
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
      result = {
        video:        get_url(fight.fight_video),
        video_cover:  get_file_value(fight.fight_video,"cover",true),
        minorities:   minorities
       }
    end

    render :json => result
  end

end