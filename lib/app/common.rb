module App

  module Common
    PLATFORM = {
      :iOS     => 0,
      :Android => 1,
    }

    I               = "Image"
    IL              = "ImageList"
    A               = "Audio"
    V               = "Video"
    T               = "Letter"

    MT = {
      :Image        => "image",
      :Audio        => "audio",
      :Video        => "video"
    }
  end

  module Model
    include App::Common

    ATOM_ATTRS = {
      :Keyword      => ['slug', 'version'],
      :Letter       => 'body',
    }
    ARRAY_FIELD     = [ 'slides' ]

    def o_to_h( model, excludes = [], includes = [], renames = {} )
      return {} if model.nil?

      attrs_to_h(model, excludes, includes, renames)
    end

    private

    def extract_attrs( model, excludes = [], includes = [])
      attrs = includes || []
      model._accessible_attributes[:default].to_a.each do |e|
        e = e.gsub(/_attributes/, "")
        next if e.blank? || excludes.include?(e)
        attrs << e
      end
      attrs
    end

    def attrs_to_h( model, excludes = [], includes = [], renames = {} )
      h = {}

      extract_attrs(model, excludes, includes).each do|e|
        val = model.send(e.to_sym)
        klass_name = val.class.name
        prefix = model.class.name.underscore + "_"
        e = e.gsub(Regexp.new(prefix), "")

        ( h[set_key(e, renames)] = ""; next ) if val.nil?

        atom_attrs = ATOM_ATTRS[klass_name.to_s.to_sym]
        unless atom_attrs.nil?
          ( (atom_attrs - excludes).each{|attr| h[set_key(e, renames)] = val.send(attr) }; next ) if e == "slug"
          h[set_key(e, renames)] = val.send(ATOM_ATTRS[klass_name.to_s.to_sym].to_sym); next
        end

        if [A, V].include?(klass_name)
          h[e+"_size"] = val.file_size.to_s
          h[e+"_duration"] = val.duration.to_s
          h[e+"_cover"] = val.cover.url if V == klass_name
        end
        (h[set_key(e, renames)] = val.file.url; next) if [I, A, V].include?(klass_name)

        # Slides
        if ARRAY_FIELD.include?(e)
          slides = []
          val.each do |img|
            copy_resources(img.file.path, I.downcase)
            slides << { :image => img.file.url }
          end
          h[e] = slides; next
        end

        h[set_key(e, renames)] = val.to_s
      end
      h
    end

    def set_key( org_name, renames = {} )
      opts = renames || {}
      new_name = opts.has_key?(org_name.to_sym) ? opts[org_name.to_sym] : org_name
    end

  end # End Model

  module Controller; end

end