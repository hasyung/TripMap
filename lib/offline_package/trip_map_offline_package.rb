module TripMapOfflinePackage

  class OfflinePackage
    @model = nil

    def initialize( instance_model )
      @model = instance_model
    end

    def create_package
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

    private :create_root_dir

  end
  
end