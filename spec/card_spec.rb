require 'spec_helper'
require 'card'
require 'fare'
require 'byebug'

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
      before { card.charge({transport: :bus}) }

      it "should successfully charge the card" do
        expect(card.balance).to eq(28.20)
      end
    end

    context "travelling by tube" do
      before { card.charge({transport: :tube, options: {start: "Holborn"}}) }

      it "should successfully temp charge the card" do
        expect(card.balance).to eq(26.80)
        card.charge({transport: :tube, options: {end: "Earls court"}})
        expect(card.balance).to eq(27)
      end

      it "should charge max amount if user didnt touch out in the end of the journey" do
        expect(card.balance).to eq(26.80)
        card.charge({transport: :tube, options: {start: "Earls court"}})
        expect(card.balance).to eq(23.60)
        card.charge({transport: :tube, options: {end: "Holborn"}})
        expect(card.balance).to eq(23.80)
      end

      it "should charge max amount if user didnt touch out and then took the bus" do
        expect(card.balance).to eq(26.80)
        card.charge({transport: :bus})
        expect(card.balance).to eq(25)
        card.charge({transport: :tube, options: {start: "Holborn"}})
        card.charge({transport: :tube, options: {end: "Earls court"}})
        expect(card.balance).to eq(22)
      end
    end

    it "should charge max amount if user didnt touch in and only touched out" do
      card.charge({transport: :tube, options: {end: "Holborn"}})
      expect(card.balance).to eq(26.80)
      card.charge({transport: :tube, options: {start: "Holborn"}})
      card.charge({transport: :tube, options: {end: "Earls court"}})
      expect(card.balance).to eq(23.80)
    end
  end
end
