require "rails_helper"

RSpec.describe InboxProcessJob, type: :job do
  describe "#perform" do
    let(:inbox_process_handler) { instance_double(InboxProcessHandler) }
    let(:account) { double(:account) }
    let(:json) { double(:json) }

    before do
      allow(InboxProcessHandler).to receive(:new).and_return(inbox_process_handler)
      allow(inbox_process_handler).to receive(:call).with(account, json)
    end

    it "should call InboxProcessHandler#call" do
      expect(inbox_process_handler).to receive(:call).with(account, json)

      InboxProcessJob.perform_now(account, json)
    end
  end
end
