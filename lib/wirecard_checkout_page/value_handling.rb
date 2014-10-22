module WirecardCheckoutPage::ValueHandling
  def missing_keys
    @missing_keys ||= []
  end

  def missing_keys?
    unless missing_keys.empty?
      missing_keys
    end
  end

  def add_missing_key(key)
    missing_keys << key
  end

  def reset_missing_keys
    missing_keys.clear
  end
end
