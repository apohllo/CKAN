module CKAN
  class Model
    protected

    def read_lazy_data
      unless @lazy_data_read
        self.class.read_remote_json_data(self.class.site + "/" + self.id).
          each do |name,value|
          self.instance_variable_set("@"+name,value)
        end
        @lazy_data_read = true
      end
    end

    def self.site=(address)
      @site = address
    end

    def self.site
      @site
    end

    def self.search=(address)
      @search = address
    end

    def self.search
      @search
    end

    def self.read_remote_json_data(address)
      JSON.parse(open(address).read)
    end

    def self.lazy_reader(*names)
      names.each do |name|
        define_method(name) do
          read_lazy_data
          instance_variable_get("@" + name.to_s)
        end
      end
    end
  end
end
