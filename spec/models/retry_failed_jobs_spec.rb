require "rails_helper"

RSpec.describe RetryFailedJobs, type: :model do
  describe ".run" do
    context "when failed jobs not exist" do
      it "should call SolidQueue::FailedExecution.all" do
        expect(SolidQueue::FailedExecution).to receive(:all)

        RetryFailedJobs.run
      end

      it "should output log" do
        expect(Rails.logger).to receive(:info).with("Failed Executions is not exist")

        RetryFailedJobs.run
      end
    end

    context "when failed jobs exit" do
      let(:job) { create(:solid_queue_job, class_name: "ActivityPubDeliveryJob", arguments: { "key" => "value" }) }
      let!(:failed_execution) { create(:solid_queue_failed_execution, job:) }

      it "should call SolidQueue::FailedExecution.all" do
        expect(SolidQueue::FailedExecution).to receive(:all)

        RetryFailedJobs.run
      end

      it "should output log" do
        expect(Rails.logger).to receive(:info).with("All Failed Executions is retry")

        RetryFailedJobs.run
      end
    end
  end
end
