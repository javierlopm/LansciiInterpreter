=begin
    Clases relativas a tablas de simbolos

    Javier Lopez     11-10552
    Patricia Reinoso 11-10851
=end

# Implementacion de tabla de simbolos
class SymbolTable
  def initialize(father = nil)
    @tb = {}
    @father = father
    @errors = []
  end

  def add_father(father)
    @father = father
  end

  def insert_symbol(identifier,content)
    if contains?identifier
      #print "Si, mira me encontre a #{identifier}  en"
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
      self.insert_symbol(i,code)
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
      #No deberia haber problemas de declaraciones en diferentes niveles
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

# Clase padre de toda instruccion y expresion
class SymbolUser                 #Jejeps no se me ocurrio otro nombre para esta clase
  def add_symbols(symbolTable)
    @symbolTable = symbolTable

    if defined?@subexpr1
      @subexpr1.add_symbols(symbolTable)
    end

    if defined?@subexpr2
      @subexpr2.add_symbols(symbolTable)
    end

    if defined?@instrucion1
      @instrucion1.add_symbols(symbolTable)
    end

    if defined?@instrucion2
      @instrucion1.add_symbols(symbolTable)
    end

  end
end

# Clase padre de constantes, ignora la tabla de simbolos
class Constant
  def add_symbols(symbolTable)
  end
end


