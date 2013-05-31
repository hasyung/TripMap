module TripMapOfflinePackage

  class OfflinePackage
    @model = nil

    KLASS_JSON = {
      # Klass     JSON
      :Scenic => ['map_id', 'id', 'name', 'is_free', 'menu_type', 'subtitle', 'slug', 'icon', 
                  'slug_icon', 'image', 'impression', 'impression_size', 'impression_duration',
                  'route', 'route_size', 'route_duration', 'description', slides: ['image']
                 ],
      :Place  => ['map_id', 'id', 'name', 'is_free', 'menu_type', 'subtitle', 'slug', 'icon', 
                  'slug_icon', 'image', 'audio', 'audio_size', 'audio_duration',
                  'video', 'video_size', 'video_duration', 'description', slides: ['image']
                 ],
    }

    def initialize( instance_model )
      @model = instance_model
    end

    def create_package
      return if @model.nil?
      create_root_dir
    end

    def create_root_dir
      base_dir = Rails.root.to_s + "/public/uploads"
      dir_paths = ['packages', 'ylxs']

      dir_paths.each do |e|
        base_dir += "/" + e
        Dir.mkdir(base_dir, 0700) unless Dir.exist?(base_dir)
      end
    end

    def copy_resources
      attrs = []
      @model._accessible_attributes[:default].to_a.each do |e|
        next if e.blank?
        #attrs << e.gsub(Regexp.new(s.class.name.downcase+"_"), "").gsub(/_attributes/, "")
        attrs << e.gsub(/_attributes/, "")
      end

=begin

"map",
 "map_id",
 "name",
 "subtitle",
 "is_free",
 "menu_type",
 "slug",
 "impression",
 "route",
 "icon",
 "slug_icon",
 "image",
 "description",
 "description_image

=end

      attrs.each do |e|
        
      end

    end

    private :create_root_dir

  end
  
end