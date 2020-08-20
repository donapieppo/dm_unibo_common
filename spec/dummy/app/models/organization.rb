class Organization < ApplicationRecord
  include DmUniboCommon::Organization
  has_many :things
end
