module DmUniboCommon::Organization

  def to_s
   "#{self.name} #{self.description}".upcase
  end

  def short_description
    "#{self.name.upcase} - #{self.description[0..70]}"
  end

end

