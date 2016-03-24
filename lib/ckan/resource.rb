require 'csv'
require 'open-uri'
require 'time'

module CKAN
  class Resource
    PROPERTIES = [:url, :format, :description, :hash]
    # Attributes used for uploading
    PROPERTIES << :name
    PROPERTIES << :content
    PROPERTIES << :resource_type
    PROPERTIES << :size
    PROPERTIES << :last_modified
    PROPERTIES << :owner

    PROPERTIES.each { |p| attr_accessor p }

    BOUNDARY = 'DEADBEEF'

    attr_reader :auth, :metadata

    def initialize(attributes = {})
      attributes.each { |key, value|
        self.send("#{key}=", value) if PROPERTIES.member? key.to_sym
      }
    end

    def get_base
      CKAN::API.api_url.chomp("/")
    end

    def get_url(url, api_key)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      request['X-CKAN-API-Key'] = api_key
      http.request(request)
    end

    def upload(api_key)
      # 1 GET storage auth
      @auth = request_auth_for_storage(api_key)
      google_access_id = @auth['fields'][4]

      # 2 POST to storage
      response = post_to_storage(@auth, api_key)

      # 3 validate upload, should 200
      upload_ok = validate_upload_at_url(response.header['location'], api_key)

      # 4 grab metadata
      @metadata = get_resource_metadata(api_key)
      if @metadata
        @name = @metadata['_label']
        @url = @metadata['_location']
        @format = @metadata['_format']
        @resource_type = 'file.upload'
        @last_modified = @metadata['_last_modified']
        @size = @metadata['_content_length']
        @hash = @metadata['_checksum']
        @owner = @metadata['uploaded-by']
      end
=begin
    {
      "_bucket"=>"ckannet-storage",
      "_checksum"=>"md5:d5409da8d9838628ffddf3326ee5113b",
      "_content_length"=>107,
      "_format"=>"text/csv",
      "_label"=>"/2012-12-02T20:26:08Z/dal_team.csv",
      "_last_modified"=>"Sun, 02 Dec 2012 20:26:09 GMT",
      "_location"=>"https://ckannet-storage.commondatastorage.googleapis.com/2012-12-02T20:26:08Z/dal_team.csv",
      "_owner"=>nil,
      "uploaded-by"=>"e6ac98a8-44c9-43c3-9678-bbedb63d0936"
    }
=end
    end

    def hash_of_metadata_at_index(index = 0)
      hash = {}
      hasheables = ['name', 'url', 'format', 'resource_type', 'last_modified', 'size', 'hash', 'owner', 'description']
      hasheables.each do |attribute|
        hash["resources__#{index}__#{attribute}".to_sym] = self.send(attribute)
      end
      hash
    end

    def hash_of_metadata_for_dataset
      hash = {}
      hasheables = ['url', 'format', 'description', 'hash']
      hasheables.each do |attribute|
        hash[attribute.to_sym] = self.send(attribute)
      end
      hash
    end

    def request_auth_for_storage(api_key)
      @timestamp = Time.now.utc
      @label = "#{@timestamp.iso8601}/#{self.name}"
      url = get_base + "/storage/auth/form/#{@label}"
      # GET /en/api/storage/auth/form/2012-12-02T180515/dal_team.csv HTTP/1.1
      response = get_url(url, api_key)
      JSON.parse(response.body) if response.body
    end

    def post_to_storage(auth, api_key)
      url = get_base + auth['action']
      uri = URI.parse(url)
      post_body = auth['fields'].each_with_object([]) do |field, post_body|
        post_body << "--#{BOUNDARY}\r\n"
        post_body << "Content-Disposition: form-data; name=\"#{field['name']}\"\r\n"
        post_body << "\r\n"
        post_body << field['value']
        post_body << "\r\n"
      end
      post_body = post_body.join + post_body_for_resource

      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request['X-CKAN-API-Key'] = api_key
      request['Content-Type'] = "multipart/form-data, boundary=#{BOUNDARY}"
      request.body = post_body
      http.request(request)
    end

    def validate_upload_at_url(url, api_key)
      # GET http://datahub.io/en/storage/upload/success_empty?label=2012-12-02T180515%2Fdal_team.csv
      response = get_url(url, api_key)
      response.code.to_i == 200
    end

    def get_resource_metadata(api_key)
      # GET 2012-12-02T180515/dal_team.csv
      url = get_base + "/storage/metadata/#{@label}"
      response = get_url(url, api_key)
      JSON.parse(response.body)
    end

    def post_body_for_resource
      post_body = []

      post_body << "--#{BOUNDARY}\r\n"
      post_body << "Content-Disposition: form-data; name=\"file\"; filename=\"#{@name}\"\r\n"
      post_body << "Content-Type: text/csv\r\n"
      post_body << "\r\n"
      post_body << @content
      post_body << "\r\n--#{BOUNDARY}--\r\n"

      post_body.join
    end
    
    # Gets the content of this resource as a CSV::Table
    # options defaults to the same options as CSV.table
    def content_csv(options={headers: true, converters: :numeric, header_converters: :symbol})
      CSV.parse content, options
    end
    
    # Gets the content of this resource, from the internet if appropriate
    def content
      @content || open(url_safe).read
    end
    
    # Gets the URL of the resource safely - some CKAN APIs return this
    # containing invalid characters such as spaces.
    # If URI thinks this is an invalid URI, escape it
    def url_safe
      URI.parse(url).to_s
    rescue URI::InvalidURIError
      URI.escape url
    end

=begin
{
    "action": "http://ckannet-storage.commondatastorage.googleapis.com/",
    "fields": [
        { "name": "x-goog-meta-uploaded-by", "value": "e6ac98a8-44c9-43c3-9678-bbedb63d0936" },
        { "name": "acl", "value": "public-read" },
        { "name": "success_action_redirect", "value": "http://datahub.io/en/storage/upload/success_empty?label=2012-12-02T180515%2Fdal_team.csv" },
        { "name": "policy","value": "eyJleHBpcmF0aW9uIjogIjIwMTItMTItMDNUMTQ6MDU6MTZaIiwKImNvbmRpdGlvbnMiOiBbeyJ4LWdvb2ctbWV0YS11cGxvYWRlZC1ieSI6ICJlNmFjOThhOC00NGM5LTQzYzMtOTY3OC1iYmVkYjYzZDA5MzYifSx7ImJ1Y2tldCI6ICJja2FubmV0LXN0b3JhZ2UifSx7ImtleSI6ICIyMDEyLTEyLTAyVDE4MDUxNS9kYWxfdGVhbS5jc3YifSx7ImFjbCI6ICJwdWJsaWMtcmVhZCJ9LHsic3VjY2Vzc19hY3Rpb25fcmVkaXJlY3QiOiAiaHR0cDovL2RhdGFodWIuaW8vZW4vc3RvcmFnZS91cGxvYWQvc3VjY2Vzc19lbXB0eT9sYWJlbD0yMDEyLTEyLTAyVDE4MDUxNSUyRmRhbF90ZWFtLmNzdiJ9LFsiY29udGVudC1sZW5ndGgtcmFuZ2UiLCAwLCAxMDAwMDAwMDAwMF1dfQ==" },
        { "name": "GoogleAccessId", "value": "GOOGC6OU3AYPNY47B66M" },
        { "name": "signature","value": "lrjPWuT3XSy8qVb6791VHl2xZXo=" },
        { "name": "key","value": "2012-12-02T180515/dal_team.csv" }
    ]
}
=end

  end
end
