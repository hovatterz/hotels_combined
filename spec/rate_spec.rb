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

    let(:subject) { Rate.from_xml(xml) }

    describe ".from_xml" do
      it "returns a new Rate based on the given data" do
        subject.price.should == 112
        subject.taxes.should == 22
        subject.currency.should == "USD"
        subject.provider.should == "SKH"
        subject.key.should == "0.3209499.1653332.-1056783794..820654902"
      end
    end

    describe "#supplier_link" do
      it "returns a supplier link" do
        subject.supplier_link(true, "ABC123").should == "http://brands.datahc.com/ProviderRedirect.aspx?Key=#{subject.key}&Label=ABC123&Splash=true&a_aid=#{HotelsCombined.configuration.affiliate_id}&brandid=#{HotelsCombined.configuration.brand_id}"
      end
    end
  end
end
