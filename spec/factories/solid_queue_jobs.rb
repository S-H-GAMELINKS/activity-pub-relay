FactoryBot.define do
  factory :solid_queue_job, class: SolidQueue::Job do
    queue_name { "default" }
    class_name { nil }
    arguments { nil }
  end
end
