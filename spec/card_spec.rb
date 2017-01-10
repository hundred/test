require 'spec_helper'
require 'card'

describe Card do

  let(:card) { described_class.new }

  describe "initial state" do
    it "should have default balance of 0" do
      expect(card.balance).to eq(0)
    end
  end

  describe "top up" do
    before { card.top_up(30) }

    it 'should successfully top up' do
      expect(card.balance).to eq(30)
    end

    context "invalid top up amount" do
      it "fails if the top up amount is string" do
        expect{card.top_up("hello")}.to raise_error("Top up amount must be higher than 0")
      end

      it "fails if the top up amount is negative" do
        expect{card.top_up(-30)}.to raise_error("Top up amount must be higher than 0")
      end

      it "fails if top up is a float (normal oyster doesnt allow this)" do
        card.top_up(30.90)
        expect(card.balance).to eq(60.90)
      end
    end
  end

  describe "when travel fare is taken off the card" do
    before { card.top_up(30) }

    context "travelling by bus" do
      before { card.touch_in({transport: :bus}) }

      it "should successfully charge the card" do
        expect(card.balance).to eq(28.20)
      end
    end

    context "travelling by tube" do
      before { card.touch_in({transport: :tube, stop: "Holborn"}) }

      it "should successfully temp charge the card" do
        expect(card.balance).to eq(26.80)
        card.touch_out({transport: :tube, stop: "Earls court"})
        expect(card.balance).to eq(27.50)
      end

      it "should charge max amount if user didnt touch out in the end of the journey" do
        expect(card.balance).to eq(26.80)
        card.touch_in({transport: :tube, stop: "Earls court"})
        expect(card.balance).to eq(23.60)
        card.touch_out({transport: :tube, stop: "Holborn"})
        expect(card.balance).to eq(24.30)
      end

      it "should charge max amount if user didnt touch out and then took the bus" do
        expect(card.balance).to eq(26.80)
        card.touch_in({transport: :bus})
        expect(card.balance).to eq(25)
        card.touch_in({transport: :tube, stop: "Holborn"})
        expect(card.balance).to eq(21.80)
        card.touch_out({transport: :tube, stop: "Earls court"})
        expect(card.balance).to eq(22.50)
      end
    end

    it "should charge max amount if user didnt touch in and only touched out" do
      card.touch_out({transport: :tube, stop: "Holborn"})
      expect(card.balance).to eq(26.80)
      card.touch_in({transport: :tube, stop: "Holborn"})
      expect(card.balance).to eq(23.60)
      card.touch_out({transport: :tube, stop: "Earls court"})
      expect(card.balance).to eq(24.30)
    end
  end

  describe "when card balance is not at least the minimum fare" do
    context "tube" do
      before { card.top_up(1.90) }

      it "should refuse entry" do
        expect{card.touch_in({transport: :tube, stop: "Holborn"})}.to raise_error("Please top up")
      end

      it "should not let the user touch out if he didnt touch in" do
        expect{card.touch_out({transport: :tube, stop: "Holborn"})}.to raise_error("Please top up")
      end
    end

    context "bus" do
      before { card.top_up(1.50) }

      it "should refuse entry" do
        expect{card.touch_in({transport: :bus})}.to raise_error("Please top up")
      end
    end
  end
end
