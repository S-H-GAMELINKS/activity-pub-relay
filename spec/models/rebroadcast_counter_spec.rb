require "rails_helper"

RSpec.describe RebroadcastCounter, type: :model do
  describe ".increment" do
    context "when cache key is not exist" do
      let(:cache_key) { Time.current.strftime("%Y-%m-%d") }

      after do
        Rails.cache.delete(cache_key)
      end

      it "create cache" do
        expect(Rails.cache.read(cache_key)).to eq nil
        RebroadcastCounter.increment

        expect(Rails.cache.read(cache_key)).to eq 1
      end
    end

    context "when cache key is exist" do
      let(:cache_key) { Time.current.strftime("%Y-%m-%d") }

      before do
        Rails.cache.write(cache_key, 1)
      end

      after do
        Rails.cache.delete(cache_key)
      end

      it "increment cache value" do
        RebroadcastCounter.increment

        expect(Rails.cache.read(cache_key)).to eq 2
      end
    end
  end
end
