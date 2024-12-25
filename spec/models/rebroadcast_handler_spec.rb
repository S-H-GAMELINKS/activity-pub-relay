require "rails_helper"

RSpec.describe RebroadcastHandler, type: :model do
  describe "#call" do
    let(:actor) { double(:actor) }
    let(:json) { double(:json) }
    let(:cache_key) { Time.current.strftime("%Y-%m-%d") }

    context "when delivery_suspend subscribe_server not exist" do
      before do
        allow(actor).to receive(:[]).with("id").and_return("https://www.example.com")
        allow(json).to receive(:[]).with("object").and_return("")
        create(:subscribe_server, domain: "example.com", inbox_url: "https://example.com/inbox", delivery_suspend: false)
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

      it "should enqueue job" do
        RebroadcastHandler.new.call(actor, json)

        expect(SolidQueue::Job.count).to eq 1
      end
    end

    context "when delivery_suspend subscribe_server exist" do
      before do
        allow(actor).to receive(:[]).with("id").and_return("https://www.example.com")
        create(:subscribe_server, domain: "example.com", inbox_url: "https://example.com/inbox", delivery_suspend: true)
      end

      after do
        Rails.cache.delete(cache_key)
      end

      it "should call ActiveJob.perform_all_later" do
        expect(ActiveJob).not_to receive(:perform_all_later)

        RebroadcastHandler.new.call(actor, json)
      end

      it "should not call RebroadcastCounter.increment" do
        expect(RebroadcastCounter).not_to receive(:increment)

        RebroadcastHandler.new.call(actor, json)
      end

      it "should not create rebroadcast counter cache" do
        RebroadcastHandler.new.call(actor, json)

        expect(Rails.cache.read(cache_key)).to eq nil
      end

      it "should not enqueue job" do
        RebroadcastHandler.new.call(actor, json)

        expect(SolidQueue::Job.count).to eq 0
      end
    end
  end
end
