module CKAN
  class Resource
    PROPERTIES = [:url, :format, :description, :hash]
    # Attributes used for uploading
    PROPERTIES << :name
    PROPERTIES << :content

    PROPERTIES.each { |p| attr_accessor p }

    def initialize(attributes = {})
      attributes.each { |key, value|
        self.send("#{key}=", value) if PROPERTIES.member? key.to_sym
      }
    end

    def add_content_of_file(content)
      @content = content
    end
  end
end
