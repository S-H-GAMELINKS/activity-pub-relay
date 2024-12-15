class RetryFailedJobs
  def self.run
    failed_executions = SolidQueue::FailedExecution.all

    if failed_executions.blank?
      Rails.logger.info "Failed Executions is not exist"
      return
    end

    failed_executions.each do |failed_execution|
      failed_execution.retry
    end

    Rails.logger.info "All Failed Executions is retry"
  end
end
