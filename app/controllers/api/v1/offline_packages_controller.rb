class Api::V1::OfflinePackagesController < Api::V1::ApplicationController

  MODELS = [ 'Scenic', 'Place' ]

  def pkg_versions
    results, segs = [], []

    MODELS.each{|e| segs << "keywordable_type='%s'"%e }
    keywords = Keyword.where(segs.join(" OR "))
    keywords.each{|e| results << { slug: e.slug, version: e.version } }

    render :json => results
  end

end