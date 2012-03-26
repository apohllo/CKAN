require 'spec_helper'

describe CKAN do
  describe "API_BASE" do
    it "should have an API_BASE constant" do
      CKAN::API_BASE.should eq "http://ckan.net/api/1/"
    end
  end
end