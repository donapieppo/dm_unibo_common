class User < ActiveRecord::Base
  include DmUniboCommon::User

  has_many :things
end
