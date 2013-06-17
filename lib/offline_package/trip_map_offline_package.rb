require 'fileutils'
require 'rubygems'
require 'zip/zip'

# Note: all associations' objects should add to white list!

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
      :Keyword      => 'slug',
      :Letter       => 'body'
    }
    ARRAY_FIELD     = [ 'slides' ]

    @@model         = nil
    @@pkg_dir       = nil
    @@rc_dir        = nil
    @@slug          = nil

    def self.create_package( instance_model )
      return if instance_model.nil?

      @@model = instance_model
      @@slug = extract_slug_val()
      @@pkg_dir = "%s/public/uploads/packages"%Rails.root.to_s
      @@rc_dir = "%s/%s/"%[@@pkg_dir, @@slug]

      layout_dirs
      collect_resources
      zip_resources
    end

    private
    def self.layout_dirs
      base_dir = Rails.root.to_s + "/public/uploads"
      pkg_dir  = base_dir + "/packages"
      slug_dir = pkg_dir + "/" + @@slug

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

    def self.extract_slug_val
      model_slug = "%s_slug"%@@model.class.name.downcase
      @@model.send(model_slug.to_sym).slug
    end

    def self.copy_resources( src_file, media_type = I.downcase )
      dst_dir = "%s%s"%[@@rc_dir, media_type.downcase]
      begin
        FileUtils.cp(src_file, dst_dir)
        true
      rescue
        false
      end
    end

    def self.collect_resources
      h = {}

      extract_attrs(["id"], ["map"]).each do |e|
        val = @@model.send(e.to_sym)
        klass_name = val.class.name
        prefix = @@model.class.name.downcase + "_"
        e = e.gsub(Regexp.new(prefix),"")

        ( h[e] = ""; next ) if val.nil?
        unless ATOM[klass_name.to_sym].nil?
          ( h[:slug] = val.send(ATOM[klass_name.to_sym].to_sym); next ) if e == "%s_slug"%@@model.class.name.downcase
          h[e] = val.send(ATOM[klass_name.to_sym].to_sym); next
        end

        if [A, V].include?(klass_name)
          h[e+"_size"] = val.file_size.to_s
          h[e+"_duration"] = val.duration.to_s
        end

        if [I, A, V].include?(klass_name)
          copy_resources(val.file.path, MT[klass_name.to_sym])
          h[e] = "%s/%s"%[MT[klass_name.to_sym], val.file.file.filename]
          next
        end

      # Slides
      if ARRAY_FIELD.include?(e)
        slides = []
        val.each do |img|
          copy_resources(img.file.path, I.downcase)
          slides << { :image => "%s/%s"%[I.downcase, img.file.file.filename] }
        end
        h[e] = slides
        next
      end

      h[e] = val.to_s
     end

      serialize(h)
    end

    def self.serialize( datum = {} )
      file_path = File.join(@@rc_dir, "%s.json"%@@slug)
      File.open(file_path, "w") do |f|
        f.write(datum.to_json)
        f.close()
      end
    end

    def self.zip_resources
      zipfile_name = "%s/%s.zip"%[@@pkg_dir, @@slug]
      File.delete(zipfile_name) if File.exist?(zipfile_name)

      Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
        Dir[File.join(@@rc_dir, '**', '**')].each do |file|
          zipfile.add(file.sub(@@rc_dir, ''), file)
        end
      end
      File.chmod(0644, zipfile_name)
    end

  end # end class
end # end module