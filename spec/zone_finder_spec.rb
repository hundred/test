require 'spec_helper'
require 'zone_finder'

describe ZoneFinder do

  describe "when travelling three zones" do
    let(:zone_finder) { described_class.new("holborn", "wimbeldon")}

    it "should count correct amount of zones" do
      expect(zone_finder.perform).to eq({count_humanize: "three", inc_zone_one: true})
    end
  end

  describe "when travelling two zones excluding first zone" do
    let(:zone_finder) { described_class.new("hammersmith", "wimbeldon")}

    it "should count correct amount of zones" do
      expect(zone_finder.perform).to eq({count_humanize: "two", inc_zone_one: false})
    end
  end

  describe "when travelling one zone in zone one only" do
    let(:zone_finder) { described_class.new("earls court", "holborn")}

    it "should count correct amount of zones" do
      expect(zone_finder.perform).to eq({count_humanize: "one", inc_zone_one: true})
    end
  end

end
