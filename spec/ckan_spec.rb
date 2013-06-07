require 'spec_helper'

describe CKAN::API do
  describe "api_base" do
    it "should have a default api_url set" do
      CKAN::API.api_url .should eq "http://ckan.net/api/1/"
    end

    it "should allow the api_url to be configured" do
      url = "http://test.ckan.net/api/1/"
      site = "http://test.ckan.net/api/1/rest/group"
      CKAN::API.api_url = "http://test.ckan.net/api/1/"
      CKAN::API.api_url .should eq url
      CKAN::Group.site.should eq site
    end
  end
end