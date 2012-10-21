class LinkedRecordIterator
  
  attr_reader :size
  
  def initialize(record_list)
    @records = record_list
    @first = @records.where(:parent_id => nil).first
    @size = @records.size
  end
  
  def [] (num)
    if num > (@size - 1) || num < 0
      return nil
    end
    
    record = @first
    
    num.times.each do |i|
      record = record.child
    end
    
    return record
  end
  
end