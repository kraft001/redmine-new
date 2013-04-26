class Date
  def formatted
    strftime('%Y-%m-%d')
  end
end

class Time
  def formatted( with_seconds = false )
    with_seconds ?
      strftime('%Y-%m-%d %H:%M:%S') :
      strftime('%Y-%m-%d %H:%M')
  end
end

