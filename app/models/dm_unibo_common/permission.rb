require_dependency "dm_unibo_common/application_record"

# user_id
# organization_id
# authlevel in DmUniboCommon::Authorization.all_level_list
#   class Authorization
#     TO_READ   = 1
#     TO_MANAGE = 2
#     TO_CESIA  = 3
module DmUniboCommon
class Permission < ApplicationRecord
  belongs_to :organization, class_name: '::Organization'
  belongs_to :user, class_name: '::User'

  validates :organization, presence: true
  validates :user, presence: true
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
