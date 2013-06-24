class Api::V1::OfflinePackagesController < Api::V1::ApplicationController

  MODELS = [ 'Scenic', 'Place' ]
  PKG_URL_SEG = "/uploads/packages/"
  PKG_PATH = "/public%s"%PKG_URL_SEG

  def pkg_versions
    results, segs = [], []

    MODELS.each{|e| segs << "keywordable_type='%s'"%e }
    keywords = Keyword.where(segs.join(" OR "))
    keywords.each{|e| results << { slug: e.slug, version: e.version, url: url_path(e.version) } }

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

  def get_offline_pkg_url
    ret = { result: "false" }

    fields = ['slug', 'version']
    (
      render :json => r(false, t("errors.api.invalid_params"), nil, nil, true); return
    ) if has_nil_value_in fields

    cv = params[:version]
    curr_url = File.exist?(phy_path(cv)) ? url_path(cv) : ""

    slug = Keyword.where(slug: params[:slug]).first
    (
      render :json => r(false, t("errors.api.slug_error"), nil, nil, true); return
    ) if slug.nil?

    is_expired = slug.version != cv
    is_creating_file = is_expired && curr_url.blank? && !File.exist?(phy_path(slug.version))
    (
      render :json => r(false, t("errors.api.creating_file"), nil, nil, true); return
    ) if is_creating_file

    render :json => r(true, nil, curr_url, url_path(slug.version), is_expired);
  end

  private

  def r( result, msg, curr_url, latest_url, is_expired = false )
    {
      result: result.to_s, msg: msg.to_s, curr_url: curr_url.to_s,
      latest_url: latest_url.to_s, is_expired: is_expired.to_s
    }
  end

  def phy_path( version )
    File.join(Rails.root, PKG_PATH, version + ".zip")
  end

  def url_path( version )
    File.join(request.env["rack.url_scheme"]+"://", request.host_with_port, PKG_URL_SEG, version + ".zip")
  end

end