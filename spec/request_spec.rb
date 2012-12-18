module HotelsCombined
  describe Request do
    describe ".city_search" do
      it "returns a list of hotels with rates" do
        response = Request.city_search({
          :city_id => 1948,
          :arrival => "2013-01-01",
          :departure => "2013-01-02",
          :guests => 2,
          :rooms => 1,
          :user_id => 504,
          :user_ip_address => "71.88.163.187",
          :user_agent => "Firefox"
        })

        response.first.class.should == Hotel
        response.first.rates.first.class.should == Rate
      end
    end
  end
end
