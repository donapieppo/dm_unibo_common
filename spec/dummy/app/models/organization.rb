class Organization < ApplicationRecord
  include DmUniboCommon::Organization

  has_many :permissions
end
