require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CKAN::Package, :vcr => { :cassette_name => "colournames package" } do
  before(:each) do
    @art_package = CKAN::Package.new("colournames")
  end
  
  describe "initialization" do
    subject { @art_package }
    its(:id) { should == "colournames" }
  end
  
  describe "#find" do
    context "without search options", :vcr => { :cassette_name => "find all packages" } do
      let(:all_packages) { CKAN::Package.find }

      it "should return an array of all packages" do
        all_packages.should be_kind_of Array
        all_packages.count.should be_between(1000,10000)
      end

      it "should consist of Package objects" do
        all_packages.first.should be_kind_of Package
      end
    end
    
    context "with search options", :vcr => { :cassette_name => "find packages tagged lod and government" } do
      let(:tagged_packages) { CKAN::Package.find(:tags => ["lod", "government"]) }

      it "should return an array of tagged packages" do
        tagged_packages.should be_kind_of Array
        tagged_packages.count.should be_between(100,1000)
      end

      it "should consist of Package objects" do
        tagged_packages.first.should be_kind_of Package
      end
    end
  end
  
  describe "#resources" do
    it "should change the package object's ID in place" do
      @art_package.id.should eq "colournames"
      @art_package.resources
      @art_package.id.should eq "53587fae-fb5f-46e5-ae55-14f9951d0808"
    end
    
    it "should return details about an individual package" do
      @art_package.resources
      @art_package.url.should eq "http://blog.doloreslabs.com/2008/03/our-color-names-data-set-is-online/"
    end
  end
  
  describe "#to_s" do
    context "before resource request" do
      it "should return the package ID in a string" do
        @art_package.to_s.should eq "CKAN::Package[colournames]"
      end
    end

    context "after resource request" do
      it "should return the updated package ID in a string" do
        @art_package.resources
        @art_package.to_s.should eq "CKAN::Package[53587fae-fb5f-46e5-ae55-14f9951d0808]"
      end
    end
  end
end