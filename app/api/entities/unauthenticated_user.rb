module Entities
  class UnauthenticatedUser < Entities::User
    unexpose :email
    unexpose :created_at
    unexpose :updated_at
  end
end
