require "rails_helper"

RSpec.describe SignatureVerificater, type: :model do
  describe "#call" do
    let(:method) { double(:mehod) }
    let(:path) { double(:path) }
    let(:headers) { double(:headers) }
    let(:body) { double(:body) }
    let(:raw_post) { double(:raw_post) }

    subject { described_class.new(method, path, headers, body, raw_post) }

    context "when headers['Sigunature'] is blank" do
      before do
        allow(headers).to receive(:[]).with("Signature").and_return(nil)
      end

      it "should return nil" do
        result = subject.call

        expect(result).to be_nil
      end
    end

    context "when headers['Sigunature'] is present" do
      before do
        allow(headers).to receive(:[]).with("Signature").and_return("Sigunature")
      end

      context "when headers['keyId'] or headers['sigunature'] is blank" do
        before do
          allow_any_instance_of(SignatureVerificater).to receive(:incompatible_signature?).and_return(true)
        end

        it "should return nil" do
          result = subject.call

          expect(result).to be_nil
        end
      end

      context "when headers['keyId'] or headers['signature'] is present" do
        before do
          allow_any_instance_of(SignatureVerificater).to receive(:incompatible_signature?).and_return(false)
        end

        context "when account is nil" do
          before do
            allow_any_instance_of(SignatureVerificater).to receive(:account_from_key_id).and_return(nil)
          end

          it "should return nil" do
            result = subject.call

            expect(result).to be_nil
          end
        end

        context "when account is not nil" do
          let(:account) { double(:account) }

          before do
            allow_any_instance_of(SignatureVerificater).to receive(:account_from_key_id).and_return(account)
            allow(Base64).to receive(:decode64).and_return("")
            allow_any_instance_of(SignatureVerificater).to receive(:build_signed_string).and_return("")
          end

          context "when account is not verified" do
            let(:key) { double(:key) }

            before do
              allow_any_instance_of(SignatureVerificater).to receive(:key_from_account).and_return(key)
              allow(key).to receive(:verify).and_return(false)
            end

            context "when account is possibly stale" do
              before do
                allow(account).to receive(:possibly_stale?).and_return(true)
                allow(account).to receive(:refresh!).and_return(account)
              end

              context "when account is not verified" do
                before do
                  allow(account).to receive_message_chain(:keypair, :public_key, :verify).and_return(false)
                end

                it "should return nil" do
                  result = subject.call

                  expect(result).to be_nil
                end
              end

              context "when account is verified" do
                before do
                  allow(account).to receive_message_chain(:keypair, :public_key, :verify).and_return(true)
                end

                it "should return account" do
                  result = subject.call

                  expect(result).to eq(account)
                end
              end
            end

            context "when account is not possibly stale" do
              before do
                allow(account).to receive(:possibly_stale?).and_return(false)
              end

              it "should return nil" do
                result = subject.call

                expect(result).to be_nil
              end
            end
          end

          context "when account is verified" do
            let(:key) { double(:key) }

            before do
              allow_any_instance_of(SignatureVerificater).to receive(:key_from_account).and_return(key)
              allow(key).to receive(:verify).and_return(true)
            end

            it "should return account" do
              result = subject.call

              expect(result).to eq(account)
            end
          end
        end
      end
    end
  end
end
