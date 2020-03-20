module DmUniboCommon::Organization

  extend ActiveSupport::Concern

  included do
    has_many :permissions, class_name: "DmUniboCommon::Permission"
    validates :name, uniqueness: { case_sensitive: false, message: "Esiste già una struttura con lo stesso nome." }
  end

  def to_s
   "#{self.name} #{self.description}".upcase
  end

  def short_description
    "#{self.name.upcase} - #{self.description[0..70]}"
  end

end

