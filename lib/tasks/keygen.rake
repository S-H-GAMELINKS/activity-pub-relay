namespace :relay do
  desc "Generate actor signature key"
  task keygen: :environment do
    Relay::Keygen.run
  end
end
