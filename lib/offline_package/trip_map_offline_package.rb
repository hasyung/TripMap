require 'fileutils'
require 'rubygems'
require 'zip/zip'

# Note: all associations' objects should be added to white list!

module TripMapOfflinePackage

  class OfflinePackage

    I               = "Image"
    A               = "Audio"
    V               = "Video"
    MT = {
      :Image        => "image",
      :Audio        => "audio",
      :Video        => "video"
    }
    ATOM = {
      :Keyword      => ['slug', 'version'],
      :Letter       => 'body'
    }
    ARRAY_FIELD     = [ 'slides' ]
    PATH_SEG        = ['/public/uploads/packages', '/public/uploads', '/packages']

    @@model         = nil
    @@pkg_dir       = nil
    @@rc_dir        = nil
    @@slug          = nil
    @@version       = nil

    def self.create_package( instance_model )
      return if instance_model.nil?

      @@model = instance_model
      @@slug, @@version = extract_slug_and_version()
      @@pkg_dir = Rails.root.to_s + PATH_SEG[0]
      @@rc_dir = "%s/%s/"%[@@pkg_dir, @@slug]

      layout_dirs
      collect_resources
      zip_resources
    end

    private

    def self.layout_dirs
      base_dir = Rails.root.to_s + PATH_SEG[1]
      pkg_dir  = base_dir + PATH_SEG[2]
      slug_dir = "%s/%s"%[pkg_dir, @@slug]

      Dir.mkdir(pkg_dir, 0755) unless Dir.exist?(pkg_dir)
      FileUtils.rm_rf(slug_dir) if Dir.exist?(slug_dir)
      Dir.mkdir(slug_dir, 0700)

      [A, V, I].each do|e|
        curr_dir = "%s/%s"%[slug_dir, e.downcase]
        Dir.mkdir(curr_dir, 0700) unless Dir.exist?(curr_dir)
      end
    end

    def self.extract_attrs( includes = [], excludes = [] )
      attrs = includes || []
      @@model._accessible_attributes[:default].to_a.each do |e|
        e = e.gsub(/_attributes/, "")
        next if e.blank? || excludes.include?(e)
        attrs << e
      end
      attrs
    end

    def self.extract_slug_and_version
      model_slug = "%s_slugs"%@@model.class.name.downcase
      # keyword = @@model.send(model_slug.to_sym)
      # ret = keyword.slug, keyword.version
      keywords = @@model.send(model_slug.to_sym)
      #ret = keyword.slug, keyword.version 
    end

    def self.copy_resources( src_file, media_type = I.downcase )
      dst_dir = @@rc_dir + media_type.downcase
      FileUtils.cp(src_file, dst_dir)
    end

    def self.collect_resources
      h = {}

      extract_attrs(["id"], ["map"]).each do |e|
        val = @@model.send(e.to_sym)
        klass_name = val.class.name
        prefix = @@model.class.name.underscore + "_"
        e = e.gsub(Regexp.new(prefix), "")

        ( h[e] = ""; next ) if val.nil?
        unless ATOM[klass_name.to_sym].nil?
          ( ATOM[klass_name.to_sym].each{|attr| h[attr] = val.send(attr) }; next ) if e == "slug"
          h[e] = val.send(ATOM[klass_name.to_sym].to_sym); next
        end

        if [A, V].include?(klass_name)
          h[e+"_size"] = val.file_size.to_s
          h[e+"_duration"] = val.duration.to_s
        end

        if [I, A, V].include?(klass_name)
          copy_resources(val.file.path, MT[klass_name.to_sym])
          h[e] = "%s/%s"%[MT[klass_name.to_sym], get_filename(val)]
          next
        end

        # Slides
        if ARRAY_FIELD.include?(e)
          slides = []
          val.each do |img|
            copy_resources(img.file.path, I.downcase)
            slides << { :image => "%s/%s"%[I.downcase, get_filename(img)] }
          end
          h[e] = slides; next
        end

      h[e] = val.to_s
     end

      serialize(h)
    end

    def self.get_filename( res_model )
      v = res_model
      ['file', 'file', 'filename'].each{|e| v = v.send e.to_sym unless v.nil? }
      v.to_s
    end

    def self.serialize( datum = {} )
      file_path = File.join(@@rc_dir, "%s.json"%@@slug)
      File.open(file_path, "w") do |f|
        f.write(datum.to_json)
        f.close()
      end
    end

    def self.zip_resources
      zipfile_name = "%s/%s.zip"%[@@pkg_dir, @@version]

      Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
        Dir[File.join(@@rc_dir, '**', '**')].each do |file|
          zipfile.add(file.sub(@@rc_dir, ''), file)
        end
      end
      File.chmod(0644, zipfile_name)
    end

  end # end class

end # end module