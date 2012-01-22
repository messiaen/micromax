class Search
  
  def self.find_around (list, item, message)
    low  = 0
    high = list.size - 1
    mid  = (high + low) / 2
    
    if list.size == 0
      return nil, nil
    end
    
    if item.send(message) <= list[low].send(message)
      return nil, list[low]
    elsif item.send(message) >= list[high].send(message)
      return list[high], nil
    end

    return Search.find_around_iter(list, item, low, mid, high, message)
  end
  
  
  def self.find_around_iter (list, item, low, mid, high, message)
    if high - low <= 1
      return list[low], list[high]
    end
  
    if list[mid].send(message) == item.send(message)
      return list[mid], list[mid + 1]
    elsif item.send(message) < list[mid].send(message)
      high = mid
    else
      low = mid
    end
  
    return find_around_iter(list, item, low, (high + low) / 2, high, message)
  end
  
end