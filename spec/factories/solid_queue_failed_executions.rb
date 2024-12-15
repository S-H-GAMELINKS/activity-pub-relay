FactoryBot.define do
  factory :solid_queue_failed_execution, class: SolidQueue::FailedExecution do
    job { nil }
    error { nil }
  end
end
