require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CKAN::Resource do
  subject do
    CKAN::Resource.new(url: 'http://foo.bar', format: 'text/csv', description: 'Fubar', hash: '0xDEADBEEF')
  end

  it "should return a Resource object" do
    subject.should be_kind_of(CKAN::Resource)
  end
end
