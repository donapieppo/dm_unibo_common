require_dependency "dm_unibo_common/application_record"

# Corresponding to DB table with columns user_id, organization_id, authlevel
# where
# user_id         -> User < ApplicationRecord with include DmUniboCommon::User
# organization_id -> Organization < ApplicationRecord with include DmUniboCommon::Organization
# authlevel       -> int in DmUniboCommon::Authorization.all_level_list
module DmUniboCommon
class Permission < ApplicationRecord
  extend DmUniboCommon::UserUpnMethods::ClassMethods

  belongs_to_dsa_user :user 

  belongs_to :organization, class_name: '::Organization'
  belongs_to :user, class_name: '::User'

  validates :organization, presence: true
  # validates :user, presence: true
  validates :authlevel, inclusion: { in: DmUniboCommon::Authorization.all_level_list, message: "Errore interno al sistema su Admin.authlevel. Contattare Assistenza." }

  # FIXME not nice
  after_save :reload_authlevels!

  def to_s
    "#{self.authlevel} #{self.user} on #{self.organization}"
  end

  def authlevel_string
    DmUniboCommon::Authorization.level_description(self.authlevel)
  end

  def reload_authlevels!
    DmUniboCommon::Authorization.authlevels_reload!
  end
end
end

DmUniboCommon::Permission.table_name = "permissions"
