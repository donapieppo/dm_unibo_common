# Use with 
# include DmUniboCommon::Organization
module DmUniboCommon::Organization
  extend ActiveSupport::Concern

  included do
    has_many :permissions, class_name: "DmUniboCommon::Permission"
    validates :code,
      uniqueness: {case_sensitive: false, message: "Esiste già una struttura con lo stesso nome."},
      presence: true
    validates :name,
      uniqueness: {case_sensitive: false, message: "Esiste già una struttura con lo stesso codice."},
      presence: true
  end

  def to_s
    "#{self.code} - #{self.name} (#{self.description})".upcase
  end

  def short_description
    "#{self.name.upcase} - #{self.description[0..70]}"
  end

  def users_with_permission_level(level_symbol = nil)
    return [] if level_symbol == nil
    level_number = ::Authorization.all_authlevels[level_symbol] or raise "Unknown DmUniboCommon::Authorization level #{level_symbol}"
    self.permissions.includes(:user).where(authlevel: level_number.to_i).map(&:user)
  end
end
