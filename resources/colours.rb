class String
  # colours
  def colourise(colour_code)
    "\e[#{colour_code}m#{self}\e[0m"
  end

  def green
    colourise(32)
  end

  def yellow
    colourise(33)
  end

  def red
    colourise(31)
  end

  def grey
    colourise(2)
  end

  def strikethrough
    colourise(9)
  end
end