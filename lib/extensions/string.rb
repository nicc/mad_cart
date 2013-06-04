class String

  def underscore
    self.dup.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end

  def demodularise
    self.split('::').last
  end

  def classify
    self
  end

  def constantize
    MadCart::Product
  end

end
