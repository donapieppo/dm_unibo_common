require_dependency "dm_unibo_common/application_record"

# Corresponding to DB table with columns user_id, organization_id, authlevel
# where
# user_id         -> User < ApplicationRecord with include DmUniboCommon::User
# organization_id -> Organization < ApplicationRecord with include DmUniboCommon::Organization
# authlevel       -> int in ::Authorization.all_authlevels.values
module DmUniboCommon
class Permission < ApplicationRecord
  extend DmUniboCommon::UserUpnMethods::ClassMethods

  belongs_to_dsa_user :user

  belongs_to :organization, class_name: "::Organization"
  belongs_to :user, class_name: "::User", optional: true

  validates :organization, presence: true
  validates :network, format: {with: /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\z/i, message: "Formato corretto di network: 137.204.13.0.", allow_nil: true}
  validates :authlevel, inclusion: {in: ::Authorization.all_authlevels.values,
                                    message: "Errore interno al sistema su authlevel. Contattare Assistenza."}

  validate :user_or_network
  # after_save :reload_authlevels_cache

  def to_s
    "#{authlevel} #{user} on #{organization}"
  end

  def authlevel_string
    ::Authorization.level_description(authlevel)
  end

  def user_or_network
    errors.add(:base, "Necessario fornire utente o network") if self.network.blank? && self.user_id.nil?
  end

  # def reload_authlevels_cache
  #   self.user.reload_authlevels_cache!
  # end
end
end

DmUniboCommon::Permission.table_name = "permissions"
