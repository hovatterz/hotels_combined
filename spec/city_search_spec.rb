module HotelsCombined
  describe CitySearch do
    let(:parameters) {
      { :city_id => 1948,
        :checkin => Chronic.parse("today").strftime("%m/%d/%Y"),
        :checkout => Chronic.parse("tomorrow").strftime("%m/%d/%Y"),
        :guests => 2,
        :rooms => 1,
        :user_id => 504,
        :user_ip_address => "71.88.163.187",
        :user_agent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.101 Safari/537.11",
        :page_size => 10 }
    }

    context "given valid parameters" do
      use_vcr_cassette "city-search-valid", :record => :new_episodes

      it "returns a list of hotels with rates" do
        hotels = CitySearch.new(parameters).hotels

        hotels.length.should == parameters[:page_size]
        hotels.first.class.should == Hotel
        hotels.first.rates.first.class.should == Rate
      end
    end

    context "given invalid parameters" do
      use_vcr_cassette "city-search-invalid", :record => :new_episodes

      it "raises an error" do
        lambda {
          CitySearch.new(parameters.merge(:city_id => nil))
        }.should raise_error(InvalidParameterError)
      end
    end
  end
end
