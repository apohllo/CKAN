module CKAN
  class Datastore < Model
    PROPERTIES = [:id, :name, :title, :version, :url, :resources, :author, :author_email, :maintainer, :maintainer_email, :license_id, :tags, :notes, :extras]
    PROPERTIES.each { |p| attr_accessor p }

    def initialize(attributes = {})
      attributes.each { |key, value|
        self.send("#{key}=", value) if PROPERTIES.member? key.to_sym
      }
    end

    def to_hash(avoidables = [])
      hash = {}
      self.instance_variables.each do |var|
        key = var.to_s.delete("@").to_sym
        hash[key] = self.instance_variable_get(var) unless avoidables.member? key
      end
      hash
    end

    def upload(api_token)
      uri = URI.parse('http://datahub.io/api/rest/dataset')
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request['X-CKAN-API-Key'] = api_token
      request['Content-Type'] = 'application/json'

      if @resources && !@resources.empty?
        # Dataset attributes
        hash_of_attributes = self.to_hash([:resources])
        hash_of_attributes.merge!(hashify_array_of_resources_v2)
        request.body = hash_of_attributes.to_json
      else
        request.body = self.to_hash.to_json
      end
      http.request(request)
    end

    def hash_of_resources
      hash = {}
      @resources.each_with_index do |r, i|
        # resource__0__name='foo'
        metadata = r.hash_of_metadata_at_index(i)
        hash.merge!(metadata)
      end
      hash
    end

    def hashify_array_of_resources_v2
      hash = {}
      array = []
      @resources.each_with_index do |r, i|
        array << r.hash_of_metadata_for_dataset
      end
      hash[:resources] = array
      hash
    end

  end
end
