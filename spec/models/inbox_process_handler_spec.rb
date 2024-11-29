require "rails_helper"

RSpec.describe InboxProcessHandler, type: :model do
  describe "#call" do
    let(:activity_pub_type_handler) { instance_double(ActivityPubTypeHandler) }
    let(:server_follow_handler) { instance_double(ServerFollowHandler) }
    let(:server_unfollow_handler) { instance_double(ServerUnfollowHandler) }
    let(:rebroadcast_handler) { instance_double(RebroadcastHandler) }
    let(:actor) { double(:actor) }
    let(:json) { double(:json) }

    before do
      allow(ActivityPubTypeHandler).to receive(:new).with(json).and_return(activity_pub_type_handler)
      allow(activity_pub_type_handler).to receive(:call).and_return(activity_pub_type)
    end

    context "when activity_type is :follow" do
      let(:activity_pub_type) { :follow }

      before do
        allow(ServerFollowHandler).to receive(:new).and_return(server_follow_handler)
        allow(server_follow_handler).to receive(:call).with(actor, json)
      end

      it "should receive ServerFollowHandler#call" do
        InboxProcessHandler.new.call(actor, json)

        expect(server_follow_handler).to have_received(:call).with(actor, json)
      end
    end

    context "when activity_type is :unfollow" do
      let(:activity_pub_type) { :unfollow }

      before do
        allow(ServerUnfollowHandler).to receive(:new).and_return(server_unfollow_handler)
        allow(server_unfollow_handler).to receive(:call).with(actor)
      end

      it "should receive ServerUnfollowHandler#call" do
        InboxProcessHandler.new.call(actor, json)

        expect(server_unfollow_handler).to have_received(:call).with(actor)
      end
    end

    context "when activity_type is :valid_for_rebroadcast" do
      let(:activity_pub_type) { :valid_for_rebroadcast }

      before do
        allow(RebroadcastHandler).to receive(:new).and_return(rebroadcast_handler)
        allow(rebroadcast_handler).to receive(:call).with(actor, json)
      end

      it "should receive RebroadcastHandler#call" do
        InboxProcessHandler.new.call(actor, json)

        expect(rebroadcast_handler).to have_received(:call)
      end
    end

    context "when activity_type is :none" do
      let(:activity_pub_type) { :none }

      before do
        allow(ServerFollowHandler).to receive(:new).and_return(server_follow_handler)
        allow(server_follow_handler).to receive(:call).with(actor, json)
        allow(RebroadcastHandler).to receive(:new).and_return(rebroadcast_handler)
        allow(rebroadcast_handler).to receive(:call).with(actor, json)
      end

      it "should not receive ServerFollowHandler#call" do
        InboxProcessHandler.new.call(actor, json)

        expect(server_follow_handler).not_to have_received(:call)
      end

      it "should not receive RebroadcastHandler#call" do
        InboxProcessHandler.new.call(actor, json)

        expect(rebroadcast_handler).not_to have_received(:call)
      end
    end
  end
end
