require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CKAN::Group do
  before(:all) do
    @art_group = CKAN::Group.new("art")
  end
  
  describe "initialization" do
    subject { @art_group }
    its(:id)    { should == "art" }
    its(:name)  { should == "art" }
  end

  describe "#find", :vcr => { :cassette_name => "find all groups" } do
    let(:all_groups) { CKAN::Group.find }
    
    it "should return an array of all groups" do
      all_groups.should be_kind_of Array
      all_groups.count.should >= 80
    end
        
    it "should consist of Group objects" do
      all_groups.first.should be_kind_of Group
    end
  end
  
  describe "#packages", :vcr => { :cassette_name => "find all group packages" } do
    let(:art_group_packages) { @art_group.packages }
    
    it "should return an array of all groups" do
      art_group_packages.should be_kind_of Array
      art_group_packages.count.should >= 10
    end
        
    it "should consist of Group objects" do
      art_group_packages.first.should be_kind_of Package
    end
  end
end