require "rails_helper"

RSpec.describe ActivityPubTypeHandler, type: :model do
  describe "#call" do
    context "when json type is Follow" do
      let(:actor) { double(:actor) }
      let(:json) { { "type" => "Follow" } }

      it "should return :follow" do
        result = ActivityPubTypeHandler.new(actor, json).call

        expect(result).to eq :follow
      end
    end

    context "when json type is Undo" do
      context "when json object type is Follow" do
        let(:actor) { double(:actor) }
        let(:json) {
          {
            "type" => "Undo",
            "object" => {
              "type" => "Follow"
            }
          }
        }

        it "should return :unfollow" do
          result = ActivityPubTypeHandler.new(actor, json).call

          expect(result).to eq :unfollow
        end
      end
    end

    context "when json type is supported" do
      context "when signature is signed" do
        context "when ALLOWED_HASHTAGS is blank" do
          context "when to include public collection address" do
            let(:actor) { double(:actor) }
            let(:json) {
              {
                "type" => "Create",
                "signature" => "HTTP signature",
                "to" => [ "https://www.w3.org/ns/activitystreams#Public" ],
                "cc" => [ "https://www.example.com/followers" ]
              }
            }

            it "should return :valid_for_rebroadcast" do
              result = ActivityPubTypeHandler.new(actor, json).call

              expect(result).to eq :valid_for_rebroadcast
            end
          end

          context "when cc include public collection address" do
            let(:actor) { double(:actor) }
            let(:json) {
              {
                "type" => "Create",
                "signature" => "HTTP signature",
                "to" => [ "https://www.example.com/followers" ],
                "cc" => [ "https://www.w3.org/ns/activitystreams#Public" ]
              }
            }

            it "should return :valid_for_rebroadcast" do
              result = ActivityPubTypeHandler.new(actor, json).call

              expect(result).to eq :valid_for_rebroadcast
            end
          end

          context "when to and cc not include public collection address" do
            let(:actor) { double(:actor) }
            let(:json) {
              {
                "type" => "Create",
                "signature" => "HTTP signature",
                "to" => [ "https://www.example.com/followers" ],
                "cc" => [ "https://www.example.com/followers" ]
              }
            }

            before do
              allow(actor).to receive(:[]).with("preferredUsername").and_return("")
            end

            it "should return :none" do
              result = ActivityPubTypeHandler.new(actor, json).call

              expect(result).to eq :none
            end
          end

          context "when pleroma relay annouce" do
            let(:actor) { double(:actor) }
            let(:json) {
              {
                "type" => "Announce",
                "signature" => "",
                "to" => [ "https://www.example.com/followers" ],
                "cc" => [ "https://www.example.com/followers" ]
              }
            }

            before do
              allow(actor).to receive(:[]).with("preferredUsername").and_return("relay")
            end

            it "should return :valid_for_rebroadcast" do
              result = ActivityPubTypeHandler.new(actor, json).call

              expect(result).to eq(:valid_for_rebroadcast)
            end
          end
        end

        context "when ALLOWED_HASHTAGS is present" do
          before do
            allow(ENV).to receive(:[]).and_call_original
            allow(ENV).to receive(:[]).with("ALLOWED_HASHTAGS").and_return("#activitypub_relay,#activitypub")
          end

          context "when not include allowed hashtags" do
            context "when to include public collection address" do
              let(:actor) { double(:actor) }
              let(:json) {
                {
                  "type" => "Create",
                  "signature" => "HTTP signature",
                  "to" => [ "https://www.w3.org/ns/activitystreams#Public" ],
                  "cc" => [ "https://www.example.com/followers" ],
                  "object" => {
                    "tag" => [
                      {
                        "type" => "Hashtag",
                        "href" => "https://www.example.com/tags/activitypub_relay",
                        "name" => "#mastodon"
                      },
                      {
                        "type" => "Hashtag",
                        "href" => "https://www.example.com/tags/activitypub_relay",
                        "name" => "#misskey"
                      }
                    ]
                  }
                }
              }

              before do
                allow(actor).to receive(:[]).with("preferredUsername").and_return("")
              end

              it "should return :none" do
                result = ActivityPubTypeHandler.new(actor, json).call

                expect(result).to eq :none
              end
            end

            context "when cc include public collection address" do
              let(:actor) { double(:actor) }
              let(:json) {
                {
                  "type" => "Create",
                  "signature" => "HTTP signature",
                  "to" => [ "https://www.example.com/followers" ],
                  "cc" => [ "https://www.w3.org/ns/activitystreams#Public" ],
                  "object" => {
                    "tag" => [
                      {
                        "type" => "Hashtag",
                        "href" => "https://www.example.com/tags/activitypub_relay",
                        "name" => "#mastodon"
                      },
                      {
                        "type" => "Hashtag",
                        "href" => "https://www.example.com/tags/activitypub_relay",
                        "name" => "#misskey"
                      }
                    ]
                  }
                }
              }

              before do
                allow(actor).to receive(:[]).with("preferredUsername").and_return("")
              end

              it "should return :none" do
                result = ActivityPubTypeHandler.new(actor, json).call

                expect(result).to eq :none
              end
            end

            context "when to and cc not include public collection address" do
              let(:actor) { double(:actor) }
              let(:json) {
                {
                  "type" => "Create",
                  "signature" => "HTTP signature",
                  "to" => [ "https://www.example.com/followers" ],
                  "cc" => [ "https://www.example.com/followers" ],
                  "object" => {
                    "tag" => [
                      {
                        "type" => "Hashtag",
                        "href" => "https://www.example.com/tags/activitypub_relay",
                        "name" => "#mastodon"
                      },
                      {
                        "type" => "Hashtag",
                        "href" => "https://www.example.com/tags/activitypub_relay",
                        "name" => "#misskey"
                      }
                    ]
                  }
                }
              }

              before do
                allow(actor).to receive(:[]).with("preferredUsername").and_return("")
              end

              it "should return :none" do
                result = ActivityPubTypeHandler.new(actor, json).call

                expect(result).to eq :none
              end
            end
          end

          context "when include allowed hashtags" do
            context "when to include public collection address" do
              let(:actor) { double(:actor) }
              let(:json) {
                {
                  "type" => "Create",
                  "signature" => "HTTP signature",
                  "to" => [ "https://www.w3.org/ns/activitystreams#Public" ],
                  "cc" => [ "https://www.example.com/followers" ],
                  "object" => {
                    "tag" => [
                      {
                        "type" => "Hashtag",
                        "href" => "https://www.example.com/tags/activitypub_relay",
                        "name" => "#mastodon"
                      },
                      {
                        "type" => "Hashtag",
                        "href" => "https://www.example.com/tags/activitypub_relay",
                        "name" => "#activitypub_relay"
                      }
                    ]
                  }
                }
              }

              it "should return :valid_for_rebroadcast" do
                result = ActivityPubTypeHandler.new(actor, json).call

                expect(result).to eq :valid_for_rebroadcast
              end
            end

            context "when cc include public collection address" do
              let(:actor) { double(:actor) }
              let(:json) {
                {
                  "type" => "Create",
                  "signature" => "HTTP signature",
                  "to" => [ "https://www.example.com/followers" ],
                  "cc" => [ "https://www.w3.org/ns/activitystreams#Public" ],
                  "object" => {
                    "tag" => [
                      {
                        "type" => "Hashtag",
                        "href" => "https://www.example.com/tags/activitypub_relay",
                        "name" => "#mastodon"
                      },
                      {
                        "type" => "Hashtag",
                        "href" => "https://www.example.com/tags/activitypub_relay",
                        "name" => "#activitypub_relay"
                      }
                    ]
                  }
                }
              }

              it "should return :valid_for_rebroadcast" do
                result = ActivityPubTypeHandler.new(actor, json).call

                expect(result).to eq :valid_for_rebroadcast
              end
            end

            context "when to and cc not include public collection address" do
              let(:actor) { double(:actor) }
              let(:json) {
                {
                  "type" => "Create",
                  "signature" => "HTTP signature",
                  "to" => [ "https://www.example.com/followers" ],
                  "cc" => [ "https://www.example.com/followers" ],
                  "object" => {
                    "tag" => [
                      {
                        "type" => "Hashtag",
                        "href" => "https://www.example.com/tags/activitypub_relay",
                        "name" => "#mastodon"
                      },
                      {
                        "type" => "Hashtag",
                        "href" => "https://www.example.com/tags/activitypub_relay",
                        "name" => "#activitypub_relay"
                      }
                    ]
                  }
                }
              }

              before do
                allow(actor).to receive(:[]).with("preferredUsername").and_return("")
              end

              it "should return :none" do
                result = ActivityPubTypeHandler.new(actor, json).call

                expect(result).to eq :none
              end
            end
          end
        end
      end

      context "when signature is not signed" do
        let(:actor) { double(:actor) }
        let(:json) {
          {
            "type" => "Create",
            "signature" => nil
          }
        }

        before do
          allow(actor).to receive(:[]).with("preferredUsername").and_return("")
        end

        it "should return :none" do
          result = ActivityPubTypeHandler.new(actor, json).call

          expect(result).to eq :none
        end
      end
    end

    context "when json type is not supported" do
      let(:actor) { double(:actor) }
      let(:json) {
        {
          "type" => "Like",
          "signature" => "HTTP signature",
          "to" => [ "https://www.w3.org/ns/activitystreams#Public" ]
        }
      }

      before do
        allow(actor).to receive(:[]).and_return("")
      end

      it "should return :none" do
        result = ActivityPubTypeHandler.new(actor, json).call

        expect(result).to eq :none
      end
    end
  end
end
