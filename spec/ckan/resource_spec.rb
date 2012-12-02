require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CKAN::Resource do
  subject do
    CKAN::Resource.new(url: 'http://foo.bar', format: 'text/csv', description: 'Fubar', hash: '0xDEADBEEF')
  end

  it "should return a Resource object" do
    subject.should be_kind_of(CKAN::Resource)
  end

  it "should add content of files" do
    file_name = 'dal_team.csv'
    file_content = File.read(file_name)

    subject.content = file_content
    subject.content.length.should == file_content.length
  end
end
