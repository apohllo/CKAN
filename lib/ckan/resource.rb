module CKAN
  class Resource
    attr_reader :url, :format, :description, :hash

    def initialize(url, format, description, hash)
      @url, @format, @description, @hash = url, format, description, hash
    end
  end
end
