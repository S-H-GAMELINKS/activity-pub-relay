# frozen_string_literal: true

# :nodoc:
class Block < ApplicationRecord
  validates :domain, presence: true, uniqueness: true
end
