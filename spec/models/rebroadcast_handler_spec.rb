require "rails_helper"

RSpec.describe RebroadcastHandler, type: :model do
  describe "#call" do
    let(:actor) { double(:actor) }
    let(:json) { double(:json) }
    let(:cache_key) { Time.current.strftime("%Y-%m-%d") }

    before do
      allow(actor).to receive(:[]).with("id").and_return("https://www.example.com")
    end

    after do
      Rails.cache.delete(cache_key)
    end

    it "should call ActiveJob.perform_all_later" do
      expect(ActiveJob).to receive(:perform_all_later)

      RebroadcastHandler.new.call(actor, json)
    end

    it "should call RebroadcastCounter.increment" do
      expect(RebroadcastCounter).to receive(:increment)

      RebroadcastHandler.new.call(actor, json)
    end

    it "should create rebroadcast counter cache" do
      RebroadcastHandler.new.call(actor, json)

      expect(Rails.cache.read(cache_key)).to eq 1
    end
  end
end
