require "rails_helper"

RSpec.describe Relay::Keygen, type: :model do
  describe ".run" do
    before do
      path = Rails.root.join("config/actor.pem")
      if File.exist?(path)
        FileUtils.rm(path)
      end
    end

    it "should generate actor signature key" do
      Relay::Keygen.run
      path = Rails.root.join("config/actor.pem")

      expect(File.exist?(path)).to be true
    end
  end
end
