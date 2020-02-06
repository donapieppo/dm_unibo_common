# user_id, organization_id, authlevel
module DmUniboCommon
class Permission < ActiveRecord::Base

  belongs_to :organization, class_name: '::Organization'
  belongs_to :user, class_name: '::User'

  validates :organization, presence: true
  validates :user, presence: true
  validates :authlevel, inclusion: { in: DmUniboCommon::Authorization.all_level_list, message: "Errore interno al sistema su Admin.authlevel. Contattare Assistenza." }

  def to_s
    "#{self.authlevel} #{self.user} on #{self.organization}"
  end

  def authlevel_string
    DmUniboCommon::Authorization.level_description(self.authlevel)
  end
end
end

