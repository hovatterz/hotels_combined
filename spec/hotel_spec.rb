module HotelsCombined
  describe Hotel do
    let(:xml) {
      xml = <<XML
<Hotel>
  <Distance>0.520027970627349</Distance>
  <ID>1064936</ID>
</Hotel>
XML
      Nokogiri::XML(xml)
    }

    describe ".from_xml" do
      it "returns a new Hotel based on the given data" do
        hotel = Hotel.from_xml(xml)
        hotel.id.should == 1064936
      end
    end
  end
end
