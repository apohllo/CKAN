require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CKAN::Datastore do
  subject do
    CKAN::Datastore.new(name: 'Fubar', title: 'Unicorn meat')
  end

  before do
    file_name = 'dal_team.csv'
    @file_content = File.read(file_name)
    @resource = CKAN::Resource.new(name: file_name)
    @resource.content = @file_content
  end

  it 'should build a post body for attachments' do
    post_body = subject.post_body_for_resources([@resource])
    post_body.should_not be_empty
    post_body.length.should > @file_content.length
    # puts "post_body =\n#{post_body}"
  end

  it 'should be able to send multiple files' do
    post_body = subject.post_body_for_resources([@resource, @resource])
    post_body.should_not be_empty
    post_body.length.should > (@file_content.length * 2)
    # puts "post_body =\n#{post_body}"
  end

  it "should return a Resource object" do
    subject.should be_kind_of(CKAN::Datastore)
  end
end

