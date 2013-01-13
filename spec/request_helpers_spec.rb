module HotelsCombined
  describe RequestHelpers do
    include RequestHelpers

    describe "#format_date" do
      it "formats a given date into YYY-MM-DD format" do
        format_date("October 12, 1991").should == "1991-10-12"
      end

      it "raises an error when not given a date" do
        lambda { format_date(nil) }.should raise_error
      end
    end

    describe "#map_params" do
      it "maps symbol keys into string keys for the API call" do
        params = map_params(:checkin => "October 10, 1991",
                            :checkout => "October 12, 1991",
                            :guests => 4,
                            :rooms => 2,
                            :user_id => 54,
                            :user_ip_address => "127.0.0.1",
                            :user_agent => "Mozilla Firefox")

        params.should == {
          "Checkin" => "1991-10-10",
          "Checkout" => "1991-10-12",
          "Guests" => 4,
          "Rooms" => 2,
          "UserID" => 54,
          "UserIPAddress" => "127.0.0.1",
          "UserAgent" => "Mozilla Firefox",
          "ApiKey" => HotelsCombined.configuration.api_key
        }
      end
    end

    describe "#request_url" do
      it "builds a request url given parameters and an API method" do
        url = request_url("SomeMethod", :foo => "Bar")
        url.to_s.should == "#{HotelsCombined.base_url}SomeMethod?foo=Bar"
      end
    end

    describe "#make_request" do
      it "makes an HTTP request and returns the response" do
        Net::HTTP.any_instance.should_receive(:start).and_return { stub(:response) }
        make_request(URI.parse("http://www.google.com"))
      end
    end

    describe "#decompress_response" do
      context "when the Content-Encoding is gzip" do
        it "returns the gunzipped response body "do
          gzip_string = StringIO.new
          writer = Zlib::GzipWriter.new(gzip_string)
          writer.write("foo")
          writer.finish

          response = stub(:response, :body => gzip_string.string,
                          :header => { "Content-Encoding" => "gzip" })
          decompress_response(response).should == "foo"
        end
      end

      context "when the Content-Encoding is not gzip" do
        it "returns the response body" do
          response = stub(:response, :body => "foo",
                          :header => { "Content-Encoding" => "foo" })
          decompress_response(response).should == "foo"
        end
      end
    end

    describe "#parse_response" do
      it "returns a Nokogiri XML document" do
        xml = parse_response("<root><test></test></root>");
        xml.class.should == Nokogiri::XML::Document
      end

      context "when there is a fault from HotelsCombined" do
        it "raises an error" do
        lambda { parse_response("<root><Fault><Code><Value>TestValue</Value></Code><Reason><Text>SomeError</Text></Reason></Fault></root>") }.should raise_error
        end
      end
    end
  end
end
