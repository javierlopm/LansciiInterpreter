class SymbolTable
  def initialize
    @tb = {}
    @errors = []
  end

  def insert(identifier,content)
    if contains?identifier
      @errors << "identifier #{identifier} already declared"
    else
      @tb[identifier] = content
    end
  end

  def delete(identifier)
    @tb.delete(identifier)
  end

  def update(identifier,content)
    @tb[identifier] = content
  end

  def contains?(identifier)
    res = @tb.has_key?identifier
  end

  def lookup(identifier)
    res = @tb[identifier]
  end

end
