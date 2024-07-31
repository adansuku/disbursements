# frozen_string_literal: true

# Order model represents an order placed by a merchant.
# Each order belongs to a specific merchant.
class Order < ApplicationRecord
  belongs_to :merchant
end
