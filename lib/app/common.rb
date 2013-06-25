module App

  module Common
    PLATFORM = {
      :iOS     => 0,
      :Android => 1,
    }
  end

  module Model
    I               = "Image"
    A               = "Audio"
    V               = "Video"
    MT = {
      :Image        => "image",
      :Audio        => "audio",
      :Video        => "video"
    }
    ATOM_ATTRS = {
      :Keyword      => ['slug', 'version'],
      :Letter       => 'body',
    }
    ARRAY_FIELD     = [ 'slides' ]

    def o_to_h( model, excludes = [], includes = [] )
      return {} if model.nil?

      attrs_to_h(model, excludes, includes)
    end

    private

    def extract_attrs( model, excludes = [], includes = [] )
      attrs = includes || []
      model._accessible_attributes[:default].to_a.each do |e|
        e = e.gsub(/_attributes/, "")
        next if e.blank? || excludes.include?(e)
        attrs << e
      end
      attrs
    end

    def attrs_to_h( model, excludes = [], includes = [] )
      h = {}

      extract_attrs(model, excludes, includes).each do|e|
        val = model.send(e.to_sym)
        klass_name = val.class.name
        prefix = model.class.name.underscore + "_"
        e = e.gsub(Regexp.new(prefix), "")

        ( h[e] = ""; next ) if val.nil?

        atom_attrs = ATOM_ATTRS[klass_name.to_s.to_sym]
        unless atom_attrs.nil?
          ( (atom_attrs - excludes).each{|attr| h[attr] = val.send(attr) }; next ) if e == "slug"
          h[e] = val.send(ATOM_ATTRS[klass_name.to_s.to_sym].to_sym); next
        end

        if [A, V].include?(klass_name)
          h[e+"_size"] = val.file_size.to_s
          h[e+"_duration"] = val.duration.to_s
        end
        (h[e] = val.file.url; next) if [I, A, V].include?(klass_name)

        # Slides
        if ARRAY_FIELD.include?(e)
          slides = []
          val.each do |img|
            copy_resources(img.file.path, I.downcase)
            slides << { :image => img.file.url }
          end
          h[e] = slides; next
        end

        h[e] = val.to_s
      end
      h
    end

  end # End Model

  module Controller; end

end