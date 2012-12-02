require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CKAN::Datastore do
  subject do
    CKAN::Datastore.new(name: 'Fubar', title: 'Unicorn meat')
  end

  it "should return a Resource object" do
    subject.should be_kind_of(CKAN::Datastore)
  end

  it 'should include attributes in to_hash' do
    subject.to_hash()[:name].should == subject.name
  end

  it 'should be hashes leaving some attributes out' do
    subject.to_hash([:resources])[:resources].should be_nil
  end
end

