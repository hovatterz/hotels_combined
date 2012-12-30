module HotelsCombined
  describe Rate do
    let(:xml) {
      xml = <<XML
<Rate>
  <ConvertedPrice>112</ConvertedPrice>
  <ConvertedTaxes>22</ConvertedTaxes>
  <Currency>USD</Currency>
  <Key>0.3209499.1653332.-1056783794..820654902</Key>
  <Price>112</Price>
  <Provider>SKH</Provider>
  <Taxes>22</Taxes>
</Rate>
XML
      Nokogiri::XML(xml)
    }

    describe ".from_xml" do
      it "returns a new Rate based on the given data" do
        rate = Rate.from_xml(xml)
        rate.price.should == 112
        rate.taxes.should == 22
        rate.currency.should == "USD"
        rate.provider.should == "SKH"
        rate.key.should == "0.3209499.1653332.-1056783794..820654902"
      end
    end
  end
end
