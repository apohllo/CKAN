require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CKAN::Resource do
  before do
    # path = File.expand_path(File.dirname(__FILE__) + '/../fixtures/storage_auth.json')
    # @storage_auth_json = File.read(path)
    @dummy_csv = File.expand_path(File.dirname(__FILE__) + '/../fixtures/dummy.csv')
  end

  subject do
    CKAN::Resource.new(url: 'http://foo.bar/', format: 'text/csv', description: 'Fubar', hash: '0xDEADBEEF')
  end

  it "should return a Resource object" do
    subject.should be_kind_of(CKAN::Resource)
  end

  it "should add content of files" do
    file_content = File.read(@dummy_csv)

    subject.content = file_content
    subject.content.length.should == file_content.length
  end

=begin
  subject.upload should make the following request:
  GET http://datahub.io/en/api/storage/auth/form/2013-03-12T03:27:24Z/Dummy
  with headers {'Accept'=>'*/*', 'User-Agent'=>'Ruby', 'X-Ckan-Api-Key'=>''}
=end
  it "should get auth for uploading" do
    action_url = '/storage/upload_handle'
    redirect_url = 'http://bar.datahub.io'
    name = 'Dummy'
    now = Time.now.utc.iso8601
    key = 'DEADBEEF'
    label = "#{now}/#{name}"
    json = {
      action: action_url,
      fields: [
        { foo: 1 },
        { bar: 2 },
        { qxz: 3 },
        { lor: 4 },
        { name: name }
      ]
    }.to_json

    # Stubs the whole handshake with the datahub.io
    stub_request(:get, "http://ckan.net/api/1/storage/auth/form/#{label}").
         with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby', 'X-Ckan-Api-Key'=>key}).
         to_return(:status => 200, :body => json, :headers => {})
    stub_request(:post, "http://ckan.net/api/1/storage/upload_handle").
         with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby', 'X-Ckan-Api-Key'=>key}).
         to_return(:status => 200, :body => 'OK', :headers => { 'location'=>redirect_url })
    stub_request(:get, redirect_url).
         with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby', 'X-Ckan-Api-Key'=>key}).
         to_return(:status => 200, :body => 'OK', :headers => {})
    stub_request(:get, "http://ckan.net/api/1/storage/metadata/#{label}").
         with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby', 'X-Ckan-Api-Key'=>key}).
         to_return(:status => 200, :body => json, :headers => {})

    VCR.eject_cassette
    VCR.turned_off do
      file_content = File.read(@dummy_csv)

      subject.name = 'Dummy'
      subject.content = file_content
      subject.upload(key)
      subject.auth.to_s.should_not be_empty
    end

    #stub_request(:any, /.*storage.*/).with(body: @storage_auth_json)

  end

  it 'should deliver a hash of attributes' do
    r = CKAN::Resource.new(name: 'foo')
    r.hash_of_metadata_at_index()[:'resources__0__name'].should == 'foo'
  end
  
  describe '#url_safe' do
    it 'should escape URLs containing spaces' do
      subject.stub(:url) {'http://localhost/foo bar baz.csv'}
      subject.url_safe.should eq('http://localhost/foo%20bar%20baz.csv')
    end
    it 'should not escape URLs that are already escaped' do
      subject.stub(:url) {'http://localhost/foo%20bar%20baz.csv'}
      subject.url_safe.should eq('http://localhost/foo%20bar%20baz.csv')
    end
  end
  
  context 'when resource URL points to a CSV' do
    before(:each) do
      VCR.turn_off!
      stub_request(:get, subject.url).to_return({
        status: 200,
        headers: {'Content-Type' => 'text/csv'},
        body: "foo,bar,baz\nWibble,Wobble,Woo\n"
      })
    end
    describe '#content' do
      context 'when @content is unset' do
        it 'should return the content from the resource' do
          subject.content.should eq("foo,bar,baz\nWibble,Wobble,Woo\n")
        end
      end
      context 'when @content is set' do
        before(:each) { subject.content = "foo,bar,baz\nOne,Two,Three\n" }
        it 'should return @content' do
          subject.content.should eq("foo,bar,baz\nOne,Two,Three\n")
        end
      end
    end
    describe '#content_csv' do
      context 'when @content is unset' do
        it 'should return a CSV::Table' do
          subject.content_csv.should be_a(CSV::Table)
        end
        it 'should return the content from the resource' do
          subject.content_csv.first[:foo].should eq('Wibble')
        end
        it 'can be called with overridden options' do
          subject.content_csv(headers: false).first.first.should eq('foo')
        end
        context 'iso-8859-1 data' do
          before(:each) do
            stub_request(:get, subject.url).to_return({
              status: 200,
              headers: {'Content-Type' => 'text/csv'},
              body: "foo,bar,baz\nWibbl\xe9,Wobbl\xe9,Woo\xe9\n"
            })
          end
          it 'can get content in a different encoding' do
            data = subject.content_csv(headers: true, encoding: 'iso-8859-1')
            data.first['foo'].should eq("Wibblé")
            data.first['baz'].should eq("Wooé")
          end
        end
      end
      context 'when @content is set' do
        before(:each) { subject.content = "foo,bar,baz\nOne,Two,Three\n" }
        it 'should return @content' do
          subject.content_csv.first[:foo].should eq('One')
        end
      end
    end
  end
    
end
