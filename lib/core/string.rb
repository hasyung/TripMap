class String
  def to_sn split = ' ', upcase = true
    self.scan(/..../).join(split).send(upcase == true ? 'upcase' : 'downcase')
  end
end