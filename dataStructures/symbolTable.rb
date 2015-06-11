class SymbolTable
  def initialize(father = nil)
    @tb = {}
    @father = father
    @errors = []
  end

  def insert_symbol(identifier,content)
    if contains?identifier
      @errors << "identifier #{identifier} already declared"
    else
      @tb[identifier] = content
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

end
