require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CKAN::Resource do
  before do
    path = File.expand_path(File.dirname(__FILE__) + '/../fixtures/storage_auth.json')
    @storage_auth_json = File.read(path)
  end

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

  it "should get auth for uploading" do
    VCR.eject_cassette
    VCR.turned_off do
      file_name = 'dal_team.csv'
      file_content = File.read(file_name)

      subject.name = file_name
      subject.content = file_content
      subject.upload('')
      subject.auth.to_s.should_not be_empty
    end

    #stub_request(:any, /.*storage.*/).with(body: @storage_auth_json)

  end
end
