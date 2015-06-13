class SymbolTable
  def initialize(father = nil)
    @tb = {}
    @father = father
    @errors = []
  end

  def insert_symbol(identifier,content)
    if contains?identifier
      puts "Si, mira me encontre a #{identifier} y ya lo tenia"
      @errors << "identifier #{identifier} already declared"
    else
      @tb[identifier] = content
    end
  end

  def insert_symbol_list(identifierList,type)
    
    case type
      when '%'
        code = 0
      when '!'
        code = 1
      when '@'
        code = 2
      else
        code = 3
    end

    identifierList.each do |i|
      self.insert_symbol(identifierList,code)
    end
  end

  def delete_symbol(identifier) #el nombre se confundia
    if @tb.has_key?(identifier) then
       @tb.delete(identifier)
    elsif @father.nil? then
      #skip NO SE QUE PONER AQUI 
    else 
      @father.delete_symbol(identifier)
    end  
  end #y si nunca lo consigue?! ERROR ??

  def update_symbol(identifier,content)
    if @tb.has_key?(identifier) then
       @tb[identifier] = content
    elsif @father.nil? then
      #skip NO SE QUE PONER AQUI
    else 
      @father.update_symbol(identifier)
    end
    
  end

  def contains?(identifier)
    if @father.nil? then
      return @tb.has_key?(identifier)
    else
      return (@tb.has_key?(identifier) or @father.contains?(identifier))
    end
    #res = @tb.has_key?identifier
  end

  def lookup(identifier)
    if @tb.has_key?(identifier) then
      return @tb[identifier]
    elsif @father.nil? then
      return nil
    else
      @father.lookup(identifier)
    end
    #res = @tb[identifier]
  end

  def show_all
    puts "My father is : #{@father}"
    puts "My table  has: "
    @tb.each do |entry|
      print "#{entry} "
    end
    puts "\nAnd my errors are:"
    @errors.each do |er|
      print "#{er} "
    end
    
  end

end
