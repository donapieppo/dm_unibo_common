# Use with 
# include DmUniboCommon::Organization
#
module DmUniboCommon::Organization

  extend ActiveSupport::Concern

  included do
    has_many :permissions, class_name: "DmUniboCommon::Permission"
    validates :code, uniqueness: { case_sensitive: false, message: "Esiste già una struttura con lo stesso nome." }
    validates :code, presence: {}
    validates :name, uniqueness: { case_sensitive: false, message: "Esiste già una struttura con lo stesso codice." }
    validates :name, presence: {}
  end

  def to_s
    "#{self.code} - #{self.name} (#{self.description})".upcase
  end

  def short_description
    "#{self.name.upcase} - #{self.description[0..70]}"
  end

end

