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
      request.body = self.to_hash.to_json
      request['X-CKAN-API-Key'] = api_token
      request['Content-Type'] = 'application/json'
      response = http.request(request)
      p response.code
      p response.body
      response
    end

  end
end
