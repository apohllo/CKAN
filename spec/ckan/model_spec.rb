require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CKAN::Model do
  subject { CKAN::Model }
  describe "attributes" do
    it { should respond_to(:site, :site=) }
    it { should respond_to(:search, :search=) }
  end
  
  
  describe "class methods" do
    let(:model) { CKAN::Model.new }
    
    describe "#read_lazy_data" do
      context "initialization" do
        it "shouldn't set @lazy_data_read" do
          model.instance_variable_defined?(:@lazy_data_read).should be false
        end
      end
    end
  end
  
  describe "helper methods" do
    it { should respond_to(:read_remote_json_data) }
    it { should respond_to(:lazy_reader) }
  end
end