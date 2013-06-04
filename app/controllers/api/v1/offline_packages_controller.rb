class Api::V1::OfflinePackagesController < Api::V1::ApplicationController

  MODELS = [ 'Scenic', 'Place' ]

  def pkg_versions
    results, segs = [], []

    MODELS.each{|e| segs << "keywordable_type='%s'"%e }
    keywords = Keyword.where(segs.join(" OR "))
    keywords.each{|e| results << { slug: e.slug, version: e.version } }

    render :json => results
  end

  def get_all_pkg_infos
    results = []

    Map.all.each do|m|
      h = { map_name: m.name }

      MODELS.each do|e|
        key = e.downcase.pluralize
        h[key.to_sym] = []

        m.send(key).each do|o|
          keyword = o.send("%s_slug"%o.class.name.downcase)
          slug_icon = o.send("%s_slug_icon"%o.class.name.downcase)
          h[key.to_sym] << {
            type: o.class.name.to_s, slug: keyword.slug,
            sulg_icon: slug_icon.nil? ? "" : slug_icon.file.to_s,
            file_size: keyword.file_size, name: o.name
          }
        end
      end # End model loop
      results << h
    end # End map loop

    render :json => results
  end

end