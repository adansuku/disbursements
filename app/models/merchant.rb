# frozen_string_literal: true

# Merchant model represents a merchant in the system.
# A merchant can have many orders, which are dependent on the merchant.
class Merchant < ApplicationRecord
  has_many :orders, dependent: :destroy
end
