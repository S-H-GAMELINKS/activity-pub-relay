require "rails_helper"

RSpec.describe ActivityPubTypeHandler, type: :model do
  describe "#call" do
    context "when json type is Follow" do
      let(:json) { { "type" => "Follow" } }

      it "should return :follow" do
        result = ActivityPubTypeHandler.new(json).call

        expect(result).to eq :follow
      end
    end

    context "when json type is Create" do
      let(:json) { { "type" => "Create" } }

      it "should return :none" do
        result = ActivityPubTypeHandler.new(json).call

        expect(result).to eq :none
      end
    end
  end
end
