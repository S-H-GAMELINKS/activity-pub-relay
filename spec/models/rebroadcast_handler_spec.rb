require "rails_helper"

RSpec.describe RebroadcastHandler, type: :model do
  describe "#call" do
    let(:actor) { double(:actor) }
    let(:json) { double(:json) }

    before do
      allow(actor).to receive(:[]).with("id").and_return("https://www.example.com")
    end

    it "should call ActiveJob.perform_all_later" do
      expect(ActiveJob).to receive(:perform_all_later)

      RebroadcastHandler.new.call(actor, json)
    end
  end
end
