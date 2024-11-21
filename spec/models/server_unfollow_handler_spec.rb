require "rails_helper"

RSpec.describe ServerUnfollowHandler, type: :model do
  describe "#call" do
    context "when actor['id'] is url" do
      context "when url is exist" do
        let(:actor) { double(:actor) }

        before do
          create(:subscribe_server, domain: "www.example.com")
          allow(actor).to receive(:[]).with("id").and_return("https://www.example.com")
        end

        it "should delete subscribe_server" do
          expect {
            ServerUnfollowHandler.new.call(actor)
          }.to change { SubscribeServer.count }.from(1).to(0)
        end
      end

      context "when url is not exist" do
        let(:actor) { double(:actor) }

        before do
          create(:subscribe_server, domain: "www.example.com")
          allow(actor).to receive(:[]).with("id").and_return("example.com")
        end

        it "should not subscribe_server" do
          expect {
            ServerUnfollowHandler.new.call(actor)
          }.not_to change { SubscribeServer.count }
        end
      end
    end

    context "when actor['id'] is not url" do
      let(:actor) { double(:actor) }

      before do
        create(:subscribe_server, domain: "www.example.com")
        allow(actor).to receive(:[]).with("id").and_return("actor")
      end

      it "should not delete subscribe_server" do
        expect {
          ServerUnfollowHandler.new.call(actor)
        }.not_to change { SubscribeServer.count }
      end
    end
  end
end
