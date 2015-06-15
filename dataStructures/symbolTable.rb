=begin
    Clases relativas a tablas de simbolos

    Javier Lopez     11-10552
    Patricia Reinoso 11-10851
=end



require_relative "Errors"


# Implementacion de tabla de simbolos
class SymbolTable
  def initialize(father = nil)
    @tb = {}
    @father = father
    @children  = []
    @errors = []
  end

  #########################
  # Funciones para insertar
  #########################

  def add_father(father)
    @father = father
  end

  def add_child(child)
    @children << child
  end

  def add_error(error)
    @errors << error
  end

  def insert_symbol(identifier,type,modifiable=true)
    if contains?identifier
      @errors.add_error(ReDeclared::new(identifier))
    else
      @tb[identifier] = {'type' => type, 'modifiable' => modifiable}
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

  ##########################
  # Metodos de modificacion
  ##########################

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

  ######################
  # Metodos de busqueda
  ######################

  def contains?(identifier)
    # if @father.nil? then
      # return @tb.has_key?(identifier)
    # else
      #No deberia haber problemas de declaraciones en diferentes niveles
      # return (@tb.has_key?(identifier) or @father.contains?(identifier))
    # end
    #res = @tb.has_key?identifier

    return @tb.has_key?(identifier)

  end

  def lookup(identifier)
    if @tb.has_key?(identifier) then
      return @tb[identifier]
    elsif @father.nil? then
      return nil
    else
      return @father.lookup(identifier)
    end
    #res = @tb[identifier]
  end

  def lookup_type(identifier)
    search = lookup(identifier)

    if search.nil?
      return nil
    else
      return search['type']
    end

  end

  def lookup_modifiable(identifier)
    search = lookup(identifier)

    if search.nil?
      return nil
    else
      return search['modifiable']
    end

  end

  def has_error?
    if @errors.size == 0
      @children.each do |c|
        if c.has_error?
          return true
        end
      end
      return false
    end

    return true
  end

  #######################
  # Metodos de impresion
  #######################

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

  def printTb
    if has_error?
      print_errors
    else
      print_tree
    end
  end


  def print_errors
    @errors.each do |e|
      puts "#{e.to_s}"
    end

    @children.each do |c|
      c.print_errors
    end
  end

  def print_tree(level=0)
    level.times do
      print "    "
    end
    print "Variable declaration level #{level}: "

    @tb.each.with_index do |content,index|
      key   = content[0]
      type = content[1]['type']


      case type
        when 0
          print '%'
        when 1
          print '!'
        when 2
          print '@'
        else
          print 'huh?'
      end

      print "#{key}"

      if index == @tb.size-1
        print "\n"
      else
        print ", "
      end

    end

    @children.each do |c|
      c.print_tree(level+1)
    end
  
  end



end

# Clase padre de toda instruccion y expresion
class SymbolUser                 #Jejeps no se me ocurrio otro nombre para esta clase
  def add_symbols(symbolTable)
    @symbolTable = symbolTable
    


    if defined?@identifier
      @identifier.add_symbols(symbolTable)
    end

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
      @instrucion2.add_symbols(symbolTable)
    end
  end

end

# Clase padre de constantes, ignora la tabla de simbolos
class Constant
  def add_symbols(symbolTable)
  end
end