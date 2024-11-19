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

    context "when json type is supported" do
      context "when signature is signed" do
        context "when to include public collection address" do
          let(:json) {
            {
              "type" => "Create",
              "signature" => "HTTP signature",
              "to" => [ "https://www.w3.org/ns/activitystreams#Public" ],
              "cc" => [ "https://www.example.com/followers" ]
            }
          }

          it "should return :valid_for_rebroadcast" do
            result = ActivityPubTypeHandler.new(json).call

            expect(result).to eq :valid_for_rebroadcast
          end
        end

        context "when cc include public collection address" do
          let(:json) {
            {
              "type" => "Create",
              "signature" => "HTTP signature",
              "to" => [ "https://www.example.com/followers" ],
              "cc" => [ "https://www.w3.org/ns/activitystreams#Public" ]
            }
          }

          it "should return :valid_for_rebroadcast" do
            result = ActivityPubTypeHandler.new(json).call

            expect(result).to eq :valid_for_rebroadcast
          end
        end

        context "when to and cc not include public collection address" do
          let(:json) {
            {
              "type" => "Create",
              "signature" => "HTTP signature",
              "to" => [ "https://www.example.com/followers" ],
              "cc" => [ "https://www.example.com/followers" ]
            }
          }

          it "should return :none" do
            result = ActivityPubTypeHandler.new(json).call

            expect(result).to eq :none
          end
        end
      end

      context "when signature is not signed" do
        let(:json) {
          {
            "type" => "Create",
            "signature" => nil
          }
        }

        it "should return :none" do
          result = ActivityPubTypeHandler.new(json).call

          expect(result).to eq :none
        end
      end
    end

    context "when json type is not supported" do
      let(:json) {
        {
          "type" => "Like",
          "signature" => "HTTP signature",
          "to" => [ "https://www.w3.org/ns/activitystreams#Public" ]
        }
      }

      it "should return :none" do
        result = ActivityPubTypeHandler.new(json).call

        expect(result).to eq :none
      end
    end
  end
end
