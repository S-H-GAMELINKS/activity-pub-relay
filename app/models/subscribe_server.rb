class SubscribeServer < ApplicationRecord
  validates :domain, presence: true
  validates :inbox_url, presence: true
end
