require "rails_helper"

RSpec.describe ServerFollowHandler, type: :model do
  describe "#call" do
    let(:actor) { double(:actor) }
    let(:json) { double(:json) }

    context "actor['preferredUsername'] is blank" do
      let(:mastodon_follow_handler) { instance_double(MastodonFollowHandler) }

      before do
        allow(actor).to receive(:[]).with("preferredUsername").and_return("")
        allow(MastodonFollowHandler).to receive(:new).with(actor, json).and_return(mastodon_follow_handler)
        allow(mastodon_follow_handler).to receive(:call)
      end

      it "should call MastodonFollowHandler#call" do
        expect(mastodon_follow_handler).to receive(:call)

        ServerFollowHandler.new.call(actor, json)
      end
    end

    context "actor['preferredUsername'] is present" do
      context "actor['preferredUsername'] is not 'relay'" do
        let(:mastodon_follow_handler) { instance_double(MastodonFollowHandler) }

        before do
          allow(actor).to receive(:[]).with("preferredUsername").and_return("mastodon")
          allow(MastodonFollowHandler).to receive(:new).with(actor, json).and_return(mastodon_follow_handler)
          allow(mastodon_follow_handler).to receive(:call)
        end

        it "should call MastodonFollowHandler#call" do
          expect(mastodon_follow_handler).to receive(:call)

          ServerFollowHandler.new.call(actor, json)
        end
      end

      context "actor['preferredUsername'] is 'relay'" do
        let(:pleroma_follow_handler) { instance_double(PleromaFollowHandler) }

        before do
          allow(actor).to receive(:[]).with("preferredUsername").and_return("relay")
          allow(PleromaFollowHandler).to receive(:new).with(actor, json).and_return(pleroma_follow_handler)
          allow(pleroma_follow_handler).to receive(:call)
        end

        it "should call PleromaFollowHandler#call" do
          expect(pleroma_follow_handler).to receive(:call)

          ServerFollowHandler.new.call(actor, json)
        end
      end
    end
  end
end
