require 'spec_helper'

describe CKAN do
  describe "API_BASE" do
    it "should have an api_base class variable" do
      CKAN::api_base.should eq "http://ckan.net/api/1/"
    end
  end
end