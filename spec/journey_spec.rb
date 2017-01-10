require 'spec_helper'
require 'fare'
require 'journey'


describe Journey do

  context "bus journey" do
    let(:journey) { described_class.new(transport: :bus, start_point: "Wimbeldon")}

    it "should have a start_point" do
      expect(journey.start_point).to eq("wimbeldon")
    end

    it "should have a basic bus fare" do
      expect(journey.basic_fare).to eq(Fare::BUS_FARE)
    end
  end

  context "tube journey" do

    describe "when user didnt touch in" do
      let(:journey) { described_class.new(transport: :tube, end_point: "Hammersmith")}

      it "should have a basic tube fare" do
        expect(journey.basic_fare).to eq(Fare::BASIC_TUBE_FARE)
      end

      it "should have an end_point" do
        expect(journey.end_point).to eq("hammersmith")
      end
    end

    describe "when user touched in and touched out" do
      let(:journey) { described_class.new(transport: :tube, start_point: "Hammersmith")}
      before { journey.complete!(end_point: "Wimbeldon")}

      it "should have a basic tube fare" do
        expect(journey.basic_fare).to eq(Fare::BASIC_TUBE_FARE)
      end

      it "should have an start_point" do
        expect(journey.start_point).to eq("hammersmith")
      end

      it "should have an end_point" do
        expect(journey.end_point).to eq("wimbeldon")
      end
    end
  end

end
