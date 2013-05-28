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
      rdir = Rails.root + "public/uploads/ylxs"
      Dir.mkdir(rdir, 0700) unless Dir.exist?(rdir)
    end

    private :create_root_dir

  end
  
end