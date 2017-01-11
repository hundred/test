require 'spec_helper'
require 'fare'
require 'zone_finder'

describe Fare do

  let(:fare) { described_class.new }

  context "tube" do
    describe "travel anywhere in zone 1" do
      it "should charge only for zone 1 - going from zone 1 to zone 1/2" do
        expect(fare.calculate_final_fare("holborn", "earls court")).to eq 2.50
      end

      it "should charge only for zone 1 - going from zone 1/2 to 1" do
        expect(fare.calculate_final_fare("earls court", "holborn")).to eq 2.50
      end
    end

    describe "travel any zone outside zone 1" do
      it "should charge for only zone number 2 - going from zone 1/2 to 2" do
        expect(fare.calculate_final_fare("earls court", "hammersmith")).to eq 2.00
      end

      it "should charge for only zone number 2 - going from zone 2 to 1/2" do
        expect(fare.calculate_final_fare("hammersmith", "earls court")).to eq 2.00
      end
    end

    describe "travel any two zones including zone 1" do
      it "should charge for two zones: 1 & 2 - going from zone 1 to zone 2" do
        expect(fare.calculate_final_fare("holborn", "hammersmith")).to eq 3.00
      end

      it "sshould charge for two zones: 1 & 2 - going from zone 2 to zone 1" do
        expect(fare.calculate_final_fare("hammersmith", "holborn")).to eq 3.00
      end
    end

    describe "travel any two zones excluding zone 1" do
      it "should charge for two zones: 2 & 3 - going from zone 2 to zone 3" do
        expect(fare.calculate_final_fare("hammersmith", "wimbeldon")).to eq 2.25
      end

      it "should charge for two zones: 2 & 3 - going from zone 3 to zone 2" do
        expect(fare.calculate_final_fare("wimbeldon", "hammersmith")).to eq 2.25
      end

      it "should charge for two zones: 2 & 3 - going from zone 1/2 to zone 3" do
        expect(fare.calculate_final_fare("earls court", "wimbeldon")).to eq 2.25
      end

      it "should charge for two zones: 2 & 3 - going from zone 3 to zone 1/2" do
        expect(fare.calculate_final_fare("wimbeldon", "earls court")).to eq 2.25
      end
    end

    describe "travel any three zones" do
      it "should charge for three zones: 1,2,3 - going from zone 1 to zone 3" do
        expect(fare.calculate_final_fare("holborn", "wimbeldon")).to eq 3.20
      end

      it "should charge for three zones: 1,2,3 - going from zone 3 to zone 1" do
        expect(fare.calculate_final_fare("wimbeldon", "holborn")).to eq 3.20
      end
    end
  end
end
