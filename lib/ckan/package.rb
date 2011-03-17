module CKAN
  class Package < Model
    self.site = API_BASE + "rest/package"
    self.search = API_BASE + "search/package"

    attr_reader :id
    lazy_reader :name, :title, :url, :version, :author, :author_email,
      :maintainer, :maintainer_email, :license_id, :notes

    def initialize(id)
      @id = id
    end

    def self.find(options=nil)
      if options.nil?
        @all_packages ||= read_remote_json_data(self.site).map{|id| Package.get(id)}
      else
        query = "?"
        query += options.to_a.
          map{|k,v| v.is_a?(Array) ? v.map{|vv| "#{k}=#{URI.encode(vv)}"}.join("&") :
            "#{k}=#{URI.encode(v)}"}.join("&")
        result = read_remote_json_data(self.search + query)
        if result["count"] != result["results"].size
          query += "&offset=#{result["results"].size}&limit=#{result["count"] + result["results"].size}"
          result["results"] += read_remote_json_data(self.search + query)["results"]
        end

        result["results"].map{|id| Package.get(id)}
      end
    end

    def resources
      read_lazy_data
      @mapped_resources ||= @resources.
        map{|r| Resource.new(r["url"],r["format"],r["description"],r["hash"])}
    end

    def to_s
      "CKAN::Package[#{@id}]"
    end

    protected
    def self.get(id)
      @package_map ||= {}
      unless @package_map[id]
        @package_map[id] = Package.new(id)
      end
      @package_map[id]
    end
  end
end
