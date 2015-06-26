=begin
    Separación en clases para las expresiones

    Javier Lopez     11-10552
    Patricia Reinoso 11-10851
=end

require_relative "../dataStructures/symbolTable"
require_relative "../dataStructures/Errors"

def printLevel(level)

  (0...level).each do
    $stdout.print " |  " #Believe in magic
  end

end


class Program

  def initialize (instrucion1,symbolTable=nil)
    @instrucion1 = instrucion1

    if symbolTable.nil?
      @symbolTable = SymbolTable::new()
    else
      @symbolTable = symbolTable
    end

    @instrucion1.add_symbols(@symbolTable)
    @instrucion1.context
    @instrucion1.execute
  end


  def get_symbol_table
    @symbolTable
  end

end

#####################################################
##                      Asign                      ##
#####################################################

class Asign < SymbolUser

  def initialize (identifier, subexpr1)

    @identifier = identifier
    @subexpr1   = subexpr1
  end

  def print(level=0)

    printLevel(level)
    puts "ASSIGN:"

    printLevel(level+1)
    puts "VARIABLE: "
    @identifier.print(level+2)

    printLevel(level+1)
    puts "EXPRESSION:"
    @subexpr1.print(level+2)
  end

  def context

    symboltype = @symbolTable.lookup_type(@identifier.get_name)
    symbolmod = @symbolTable.lookup_modifiable(@identifier.get_name)

    if symboltype.nil? then
      # Error: No declarado
      @symbolTable.add_error(Undeclared::new(@identifier.get_name))
    elsif symbolmod.nil? or symbolmod.eql?false then
      # no se debe modificar esta variable
      @symbolTable.add_error(NotModifiable::new(@identifier.get_name))
    else

      unless symboltype.eql? @subexpr1.type then
        # Error: Tipo
        @symbolTable.add_error(AsignError::new(@identifier.get_name,symboltype,@subexpr1.type))
      end
    end
    @subexpr1.context

  end

  def execute
    #puts "ASIGNACION"
    value      = @subexpr1.execute
    identifier = @identifier.get_name

    if @symbolTable.lookup_type(identifier).eql?2
      if value.eql?'#'
            @symbolTable.update_value(
              identifier,value,@subexpr1.get_height,@subexpr1.get_width)
          else
            @symbolTable.update_value(
              identifier,value,@subexpr1.get_height,@subexpr1.get_width)
          end
    else
      @symbolTable.update_value(identifier, value)
    end
    #puts @symbolTable.lookup_value(@identifier.get_name)
  end

end

#####################################################
##                    SECUENCE                     ##
#####################################################

class Secuence < SymbolUser

  def initialize (instrucion1, instrucion2)
    @instrucion1 = instrucion1
    @instrucion2 = instrucion2
  end

  def print(level=0)
    @instrucion1.print(level)
    @instrucion2.print(level)
  end

  def context
    @instrucion1.context
    @instrucion2.context
  end

  def execute
    status = @instrucion1.execute
    status = @instrucion2.execute
  end

end

#####################################################
##                      Read                       ##
#####################################################

class Read < SymbolUser

  def initialize (identifier)

    @identifier = identifier
  end

  def print(level=0)

    printLevel(level)
    puts "READ:"

    printLevel(level+1)
    puts "VARIABLE: "
    @identifier.print(level+2)
  end

  def context

    symboltype = @symbolTable.lookup_type(@identifier.get_name)

    if symboltype.nil? then
      # Error: No declarado
      @symbolTable.add_error(Undeclared::new(@identifier.get_name))
    else
      if symboltype.eql?2 then
        # Error: Tipo
        @symbolTable.add_error(ReadError::new(symboltype))
      end
    end
  end

  def execute
    value = STDIN.gets.chomp
    identifier = @identifier.get_name

    case @symbolTable.lookup_type(identifier)
      when 0  #Chequeo de enteros
        res = Integer(value)
        if res.nil?
          puts "Error conversion a entero fallida"
        else
          if is32bits?(res)
            @symbolTable.update_value(identifier,value)
          else
            error = Overflow::new("Read")
            abort (error.to_s) 
          end
        end

      when 1  #Chequeo de booleanos
        if    value == "true" 
          @symbolTable.update_value(identifier,true)
        elsif value == "false"
          @symbolTable.update_value(identifier,false)
        else
          error = DynamicReadError::new("Bad formed boolean")
          abort(error.to_s)
        end
      
      when 2
        if value =~ /(\/|\\|\||\_|\-|\ )*/ #Deberiamos poder asignar # tambien?
          if value.size.eql?0
            value = "#"
            @symbolTable.update_value(identifier,value,0,0)
          else
            @symbolTable.update_value(identifier,value,1,value.size)
          end
        else
          error = DynamicReadError::new("Bad formed canvas")
          abort(error.to_s)
        end
      
    end
      
  end

end

#####################################################
##                      WRITE                      ##
#####################################################

class Write < SymbolUser

  def initialize (subexpr1)

    @subexpr1 = subexpr1
  end

  def print(level=0)

    printLevel(level)
    puts "WRITE:"

    printLevel(level+1)
    puts "VARIABLE: "
    @subexpr1.print(level+2)
  end

  def context

    @subexpr1.context

    unless @subexpr1.type.eql?2 then
      #ERROR: debe ser Canvas
      @symbolTable.add_error(WriteError::new(@subexpr1.type))
    end
  end

  def execute
    value = @subexpr1.execute
    #Debemos generar error en caso de encontrarlo
    puts value
  end
end

######################################################
##                  Condicionales                   ##
######################################################

class Conditional < SymbolUser

  def initialize (subexpr1, instrucion1)

    @subexpr1 = subexpr1
    @instrucion1 = instrucion1
  end

  def print(level=0)
    printLevel(level)
    puts "CONDITIONAL STATEMENT:"

    printLevel(level+1)
    puts "CONDITION:"
    @subexpr1.print(level+2)

    printLevel(level+1)
    puts "THEN:"
    @instrucion1.print(level+2)
  end

  def context

    @subexpr1.context

    unless @subexpr1.type.eql? 1 then
      # Error: Debe ser de tipo booleano
      @symbolTable.add_error(ConditionalError::new(@subexpr1.type))
    end
    @instrucion1.context

  end

  def execute
    if @subexpr1.execute then
      @instrucion1.execute
    end
  end

end

class Conditional2 < Conditional

  def initialize (subexpr1, instrucion1, instrucion2)

    @subexpr1 = subexpr1
    @instrucion1 = instrucion1
    @instrucion2 = instrucion2
  end

  def print(level=0)
    printLevel(level)
    puts "CONDITIONAL STATEMENT:"

    printLevel(level+1)
    puts "CONDITION:"
    @subexpr1.print(level+2)

    printLevel(level+1)
    puts "THEN:"
    @instrucion1.print(level+2)

    printLevel(level+1)
    puts "ELSE:"
    @instrucion2.print(level+2)
  end


  def context

    @subexpr1.context

    unless @subexpr1.type.eql? 1 then
      # Error: Debe ser de tipo booleano
      @symbolTable.add_error(ConditionalError::new(@subexpr1.type))
    end
    @instrucion1.context
    @instrucion2.context
  end

  def execute
    if @subexpr1.execute then
      @instrucion1.execute
    else
      @instrucion2.execute
    end
  end

end

#####################################################
##                    Iteraciones                  ##
#####################################################

class IIteration < SymbolUser

  def initialize (subexpr1, instrucion1)

    @subexpr1 = subexpr1
    @instrucion1 = instrucion1
  end

  def print(level=0)
    printLevel(level)
    puts "WHILE STATEMENT:"

    printLevel(level+1)
    puts "CONDITION:"
    @subexpr1.print(level+2)

    printLevel(level+1)
    puts "DO:"
    @instrucion1.print(level+2)

  end

  def context

    @subexpr1.context

    unless @subexpr1.type.eql?1 then
      @symbolTable.add_error(IIterationError::new(@subexpr1.type))
    end
    @instrucion1.context
  end

  def execute
    while @subexpr1.execute do
      @instrucion1.execute
    end
  end

end

class DIteration < SymbolUser

  def initialize(subexpr1, subexpr2, instrucion1)

    @subexpr1 = subexpr1
    @subexpr2 = subexpr2
    @instrucion1 = instrucion1

  end

  def print(level=0)
    printLevel(level)
    puts "RANGE ITERATION STATEMENT:"

    printLevel(level+1)
    puts "START:"
    @subexpr1.print(level+2)

    printLevel(level+1)
    puts "END:"
    @subexpr2.print(level+2)

    printLevel(level+1)
    puts "DO:"
    @instrucion1.print(level+2)
  end

  def context

    @subexpr1.context
    @subexpr2.context

    unless @subexpr1.type.eql?0 then
      @symbolTable.add_error(DIterationError::new(@subexpr1.type))
    end
    unless @subexpr2.type.eql?0 then
      @symbolTable.add_error(DIterationError::new(@subexpr2.type))
    end

    @instrucion1.context
  end

  def execute
    inf = @subexpr1.execute
    sup = @subexpr2.execute

    # n = [sup - inf + 1, 0].max
    # i = inf

    (sup-inf+1).times do |i|
      @instrucion1.execute
    end 

  end

end

class DIteration2 < SymbolUser


  def initialize(identifier,symbolTable,subexpr1, subexpr2, instrucion1)

    # def initialize(identifier, subexpr1, subexpr2, instrucion1)

    @symbolTable = symbolTable
    @identifier  = identifier    #jejeps... si lo necesitabamos :$
    @subexpr1    = subexpr1
    @subexpr2    = subexpr2
    @instrucion1 = instrucion1

  end

  def add_symbols(symbolTable)
    symbolTable.add_child(@symbolTable)
    @symbolTable.add_father(symbolTable)
    @instrucion1.add_symbols(@symbolTable)
    @subexpr1.add_symbols(@symbolTable)
    @subexpr2.add_symbols(@symbolTable)
  end


  def print(level=0)
    printLevel(level)
    puts "VARIABLE RANGE ITERATION STATEMENT:"

    printLevel(level+1)
    puts "VARIABLE:"
    @identifier.print(level+2)

    printLevel(level+1)
    puts "START:"
    @subexpr1.print(level+2)

    printLevel(level+1)
    puts "END:"
    @subexpr2.print(level+2)

    printLevel(level+1)
    puts "DO:"
    @instrucion1.print(level+2)

  end

  def context
    @subexpr1.context
    @subexpr2.context

    unless @subexpr1.type.eql?0 then
      @symbolTable.add_error(DIterationError::new(@subexpr1.type))
    end
    unless @subexpr2.type.eql?0 then
      @symbolTable.add_error(DIterationError::new(@subexpr2.type))
    end

    @instrucion1.context
  end

  def execute
    inf = @subexpr1.execute
    sup = @subexpr2.execute

    # n = [sup - inf + 1, 0].max
    # i = inf

    (sup-inf+1).times do |i|
      @symbolTable.update_value(@identifier,i)
      @instrucion1.execute
    end 

  end

end


###############################################
##                  BLOCK                    ##
###############################################

class VarBlock < SymbolUser

  def initialize(symbolTable,instrucion1)
    @symbolTable = symbolTable
    @instrucion1 = instrucion1
  end

  def add_symbols(symbolTable)
    symbolTable.add_child(@symbolTable)
    @symbolTable.add_father(symbolTable)
    @instrucion1.add_symbols(@symbolTable)
  end

  def print(level=0)
    printLevel(level)
    puts "DECLARE BLOCK STATEMENT:"

    printLevel(level+1)
    puts "EXECUTE:"
    @instrucion1.print(level+2)

  end

  def context
    @instrucion1.context
  end

  def execute
    @instrucion1.execute
  end

end

class Block < SymbolUser

  def initialize(instrucion1)
    @instrucion1 = instrucion1
  end

  def print(level=0)
    printLevel(level)
    puts "BLOCK STATEMENT:"

    printLevel(level+1)
    puts "EXECUTE:"
    @instrucion1.print(level+2)

  end

  def context
    @instrucion1.context
  end

  def execute
    @instrucion1.execute
  end
end


=begin
@type indica el tipo de la salida
type = 0 ==> Aritmetic 
type = 1 ==> Boolean
type = 2 ==> Canvas
type = 3 ==> Cualquier tipo
=end

############################################
##           Expresiones binarias         ##
############################################

class BinExpr < SymbolUser

  attr_accessor:subexpr1
  attr_accessor:subexpr2

  def initialize (subexpr1, subexpr2)

    @subexpr1 = subexpr1
    @subexpr2 = subexpr2
  end

  def print(level=0)
    printLevel(level)
    puts "OPERATION: #{@op}"
    @subexpr1.print(level+1)
    @subexpr2.print(level+1)
  end
end


class ExprSum < BinExpr

  attr_accessor:op
  attr_accessor:type

  def initialize(subexpr1, subexpr2)
    super
    @op = "+"
    @type = 0
  end

  def context ()
    @subexpr1.context
    @subexpr2.context

    unless @type.eql? @subexpr1.type and @type.eql? @subexpr2.type then
      # ERROR: debe ser entero
      @symbolTable.add_error(TypeError::new(@op, @subexpr1.type, @subexpr2.type))
    end

  end

  def execute
    
    result = @subexpr1.execute + @subexpr2.execute
    if is32bits?(result) then
      return result
    else 
      error = Overflow::new(@op)
      abort (error.to_s)      
    end

  end

end

class ExprSubs < BinExpr

  attr_accessor:op
  attr_accessor:type

  def initialize(subexpr1, subexpr2)
    super
    @op = "-"
    @type = 0
  end

  def context ()
    @subexpr1.context
    @subexpr2.context

    unless @type.eql? @subexpr1.type and @type.eql? @subexpr2.type then
      # ERROR: debe ser entero
      @symbolTable.add_error(TypeError::new(@op, @subexpr1.type, @subexpr2.type))
    end
  end

  def execute
  
    result = @subexpr1.execute - @subexpr2.execute
    if is32bits?(result) then
      return result
    else 
      error = Overflow::new(@op)
      abort (error.to_s)
    end
  end

end

class ExprMult < BinExpr

  attr_accessor:op
  attr_accessor:type

  def initialize(subexpr1, subexpr2)
    super
    @op = "*"
    @type = 0
  end

  def context ()
    @subexpr1.context
    @subexpr2.context

    unless @type.eql? @subexpr1.type and @type.eql? @subexpr2.type then
      # ERROR: debe ser entero
      @symbolTable.add_error(TypeError::new(@op, @subexpr1.type, @subexpr2.type))
    end
  end

  def execute
    result = @subexpr1.execute * @subexpr2.execute
    if is32bits?(result) then
      return result
    else 
      error = Overflow::new(@op)
      abort (error.to_s)
    end
  end
end

class ExprDiv < BinExpr

  attr_accessor:op
  attr_accessor:type

  def initialize(subexpr1, subexpr2)
    super
    @op = "/"
    @type = 0
  end

  def context ()
    @subexpr1.context
    @subexpr2.context

    unless @type.eql? @subexpr1.type and @type.eql? @subexpr2.type then
      # ERROR: debe ser entero
      @symbolTable.add_error(TypeError::new(@op, @subexpr1.type, @subexpr2.type))
    end
  end

  def execute
    div = @subexpr2.execute
    if div.eql?0 then
      error = DivCero::new(@subexpr2)
      abort (error.to_s)
    else
      return (@subexpr1.execute / div)
    end
  end
end

class ExprMod < BinExpr

  attr_accessor:op
  attr_accessor:type

  def initialize(subexpr1, subexpr2)
    super
    @op = "%"
    @type = 0
  end

  def context ()
    @subexpr1.context
    @subexpr2.context

    unless @type.eql? @subexpr1.type and @type.eql? @subexpr2.type then
      # ERROR: debe ser entero
      @symbolTable.add_error(TypeError::new(@op, @subexpr1.type, @subexpr2.type))
    end
  end

  def execute
    div = @subexpr2.execute
    if div.eql?0 then
     error = DivCero::new(@subexpr2)
      abort (error.to_s)
    else
      return (@subexpr1.execute % div)
    end
  end

end

class ExprAnd < BinExpr

  attr_accessor:op
  attr_accessor:type

  def initialize(subexpr1, subexpr2)
    super
    @op = "/\\"
    @type = 1
  end

  def context ()
    @subexpr1.context
    @subexpr2.context

    unless @type.eql? @subexpr1.type and @type.eql? @subexpr2.type then
      # ERROR: debe ser booleano
      @symbolTable.add_error(TypeError::new(@op, @subexpr1.type, @subexpr2.type))
    end

  end

  def execute
    return (@subexpr1.execute and @subexpr2.execute)
  end

end

class ExprOr < BinExpr

  attr_accessor:op
  attr_accessor:type

  def initialize(subexpr1, subexpr2)
    super
    @op = "\\/"
    @type = 1
  end

  def context ()
    @subexpr1.context
    @subexpr2.context

    unless @type.eql? @subexpr1.type and @type.eql? @subexpr2.type then
      # ERROR: debe ser booleano
      @symbolTable.add_error(TypeError::new(@op, @subexpr1.type, @subexpr2.type))
    end
  end

  def execute
    return (@subexpr1.execute or @subexpr2.execute)
  end

end

class ExprLess < BinExpr

  attr_accessor:op
  attr_accessor:type

  def initialize(subexpr1, subexpr2)
    super
    @op = "<"
    @type = 1
  end


  def context ()
    @subexpr1.context
    @subexpr2.context

    unless @subexpr1.type.eql?0 and @subexpr2.type.eql?0 then
      # ERROR: debe ser entero
      @symbolTable.add_error(TypeError::new(@op, @subexpr1.type, @subexpr2.type))
    end
  end

  def execute
    return (@subexpr1.execute < @subexpr2.execute)
  end

end

class ExprLessEql < BinExpr

  attr_accessor:op
  attr_accessor:type

  def initialize(subexpr1, subexpr2)
    super
    @op = "<="
    @type = 1
  end

  def context ()
    @subexpr1.context
    @subexpr2.context

    unless @subexpr1.type.eql?0 and @subexpr2.type.eql?0 then
      # ERROR: debe ser entero
      @symbolTable.add_error(TypeError::new(@op, @subexpr1.type, @subexpr2.type))
    end
  end

  def execute
    return (@subexpr1.execute <= @subexpr2.execute)
  end

end

class ExprMore < BinExpr


  attr_accessor :op
  attr_accessor :type

  def initialize(subexpr1, subexpr2)
    super
    @op = ">"
    @type = 1
  end


  def context ()
    @subexpr1.context
    @subexpr2.context

    unless @subexpr1.type.eql?0 and @subexpr2.type.eql?0 then
      # ERROR: debe ser entero
      @symbolTable.add_error(TypeError::new(@op, @subexpr1.type, @subexpr2.type))
    end
  end

  def execute
    return (@subexpr1.execute > @subexpr2.execute)
  end

end

class ExprMoreEql < BinExpr

  attr_accessor:op
  attr_accessor:type

  def initialize(subexpr1, subexpr2)
    super
    @op = ">="
    @type = 1
  end


  def context ()
    @subexpr1.context
    @subexpr2.context

    unless @subexpr1.type.eql?0 and @subexpr2.type.eql?0 then
      # ERROR: debe ser entero
      @symbolTable.add_error(TypeError::new(@op, @subexpr1.type, @subexpr2.type))
    end
  end

  def execute
    return (@subexpr1.execute >= @subexpr2.execute)
  end

end

class ExprEql < BinExpr

  attr_accessor:op
  attr_accessor:type

  def initialize(subexpr1, subexpr2)
    super
    @op = "="
    @type = 1
  end


  def context ()
    @subexpr1.context
    @subexpr2.context

    unless @subexpr1.type.eql?@subexpr2.type then
      # ERROR: debe ser del mismo tipo
      @symbolTable.add_error(TypeError::new(@op, @subexpr1.type, @subexpr2.type))
    end
  end

  def execute
    return (@subexpr1.execute == @subexpr2.execute)
  end
end

class ExprDiff < BinExpr

  attr_accessor:op
  attr_accessor:type

  def initialize(subexpr1, subexpr2)
    super
    @op = "/="
    @type = 1
  end

  def context ()
    @subexpr1.context
    @subexpr2.context

    unless @subexpr1.type.eql?@subexpr2.type then
      # ERROR: debe ser del mismo tipo
      @symbolTable.add_error(TypeError::new(@op, @subexpr1.type, @subexpr2.type))
    end

  end

  def execute
    return (@subexpr1.execute != @subexpr2.execute)
  end

end

class ExprVerConcat < BinExpr

  attr_accessor:op
  attr_accessor:type

  def initialize(subexpr1, subexpr2)
    super
    @op = "&"
    @type = 2
  end

  def context ()
    @subexpr1.context
    @subexpr2.context

    unless @type.eql?@subexpr1.type and @type.eql?@subexpr2.type then
      # ERROR: debe ser canvas
      @symbolTable.add_error(TypeError::new(@op, @subexpr1.type, @subexpr2.type))
    end

  end

  def execute
    value1 = @subexpr1.execute
    value2 = @subexpr2.execute

    if value1.eql?'#' and value2.eql?'#'
      @height = 0
      @width  = 0
      return '#'
    elsif value1.eql?'#' and not value2.eql?'#'
      @height = @subexpr2.get_width
      @width  = @subexpr2.get_height
      return value2
    elsif not value1.eql?'#' and value2.eql?'#'
      @height = @subexpr1.get_width
      @width  = @subexpr1.get_height
      return value1
    else
      if @subexpr1.get_width.eql?@subexpr2.get_width
        @width  = @subexpr2.get_width
        @height = @subexpr1.get_height + @subexpr2.get_height
        return value1 + "\n" + value2
      else
        name1 = @subexpr1.class.name=="ExprId" ? @subexpr1.get_name : "CONST"
        name2 = @subexpr2.class.name=="ExprId" ? @subexpr2.get_name : "CONST"
        
        err = NotMatchingWidth::new(name1,name2,
                                    @subexpr1.get_width,@subexpr2.get_width,
                                    @subexpr1.get_height,@subexpr2.get_height
                                    )
        abort(err.to_s)
      end
    end

  end

  def get_width
    @width
  end

  def get_height
    @height
  end

end

class ExprHorConcat < BinExpr

  attr_accessor:op
  attr_accessor:type

  def initialize(subexpr1, subexpr2)
    super
    @op = "~"
    @type = 2
  end

  def context
    @subexpr1.context
    @subexpr2.context

    unless @type.eql?@subexpr1.type and @type.eql?@subexpr2.type then
      # ERROR: debe ser canvas
      @symbolTable.add_error(TypeError::new(@op, @subexpr1.type, @subexpr2.type))
    end

  end

  def execute
  end
end

###############################################
##           Expresiones unarias             ##
###############################################

class UnExpr < SymbolUser

  attr_accessor:subexpr1

  def initialize (subexpr1)

    @subexpr1 = subexpr1
  end

  def print(level=0)
    printLevel(level)
    puts "OPERATION: #{@op}"
    @subexpr1.print(level+1)
  end
end


class ExprUnMinus < UnExpr

  attr_accessor:op
  attr_accessor:type

  def initialize(subexpr1)
    super
    @op = "-"
    @type = 0
  end

  def context
    @subexpr1.context

    unless @type.eql? @subexpr1.type then
      @symbolTable.add_error(UnaryError::new(@op,1,2))
    end

  end

  def execute
    return (-@subexpr1.execute)
  end

end

class ExprNot < UnExpr

  attr_accessor:op
  attr_accessor:type

  def initialize(subexpr1)

    super
    @op = "^"
    @type = 1
  end

  def context
    @subexpr1.context

    unless @type.eql? @subexpr1.type then
      @symbolTable.add_error(UnaryError::new(@op,0,2))
    end
  end 

  def execute
    return (not @subexpr1.execute)
  end
end

class ExprTranspose < UnExpr

  attr_accessor:op
  attr_accessor:type

  def initialize(subexpr1)

    super
    @op = "'"
    @type = 2
  end

  def context
    @subexpr1.context

    unless @type.eql? @subexpr1.type @type then
      @symbolTable.add_error(UnaryError::new(@op,0,1))
    end

  end

  def execute

  end

end

#####################################################
##             Expresiones constantes              ##
#####################################################

class ExprParenthesis < SymbolUser

  attr_accessor:subexpr1
  attr_accessor:type

  def initialize(subexpr1)

    @lp = "("
    @rp = ")"
    @subexpr1 = subexpr1
    @type = 3
  end

  def context
    @subexpr1.context

    if @type.eql?3 then
      @type = @subexpr1.type
    end

  end

  def execute
    return @subexpr1.execute
  end
end

class ExprNumber < Constant

  attr_accessor :subexpr1
  attr_accessor :type

  def initialize(subexpr1)

    @subexpr1 = subexpr1
    @type = 0
  end

  def print(level=0)
    printLevel(level)
    puts "NUMBER: #{@subexpr1}"
  end

  def context
  end

  def execute
    return Integer(@subexpr1)
  end

end

class ExprTrue < Constant

  attr_accessor:subexpr1
  attr_accessor:type

  def initialize()

    @subexpr1 = "true"
    @type = 1
  end

  def print(level=0)
    printLevel(level)
    puts "BOOL: #{@subexpr1}"
  end

  def context
  end

  def execute
    return true
  end

end

class ExprFalse < Constant

  attr_accessor:subexpr1
  attr_accessor:type

  def initialize()

    @subexpr1 = "false"
    @type = 1
  end

  def print(level=0)
    printLevel(level)
    puts "BOOL: #{@subexpr1}"
  end

  def context
  end

  def execute
    return false
  end

end

class ExprId < Constant

  attr_accessor :identifier
  attr_accessor :type

  def initialize(identifier)

    @identifier = identifier
    @type = 3
  end

  def add_symbols(symbolTable)
    @symbolTable = symbolTable
  end

  def print(level=0)
    printLevel(level)
    puts "IDENTIFIER: #{@identifier}"
  end


  def context
    symboltype = @symbolTable.lookup_type(@identifier)
    if symboltype.nil? then
      # Error: No declarado
      @symbolTable.add_error(Undeclared::new(@identifier))
    else
      if @type.eql?3 then
        @type = symboltype
      end
    end
  end

  def execute
    value = @symbolTable.lookup_value(@identifier)
    if value.nil? then
      error = NotInitialize::new(@identifier)
      puts error
      exit
    else
      return value
    end
  end

  def get_name
    return @identifier
  end

  def get_type
    return @type
  end

  def get_width
    @symbolTable.lookup_width(@identifier)
  end

  def get_height
    @symbolTable.lookup_height(@identifier)
  end
end

class ExprCanvas < Constant

  attr_accessor:subexpr1
  attr_accessor:type

  def initialize(canvas)

    @subexpr1 = canvas
    @type = 2
  end

  def print(level=0)
    printLevel(level)
    puts "CANVAS: #{@subexpr1}"
  end

  def context
  end

  def execute
    return @subexpr1
  end

  def get_height
    1
  end

  def get_width
    @subexpr1.size
  end

end

class ExprEmptyCanvas < Constant

  attr_accessor:op
  attr_accessor:type

  def initialize()

    @subexpr1 = "#"
    @type = 2
  end

  def print(level=0)
    printLevel(level)
    puts "CANVAS: #{@subexpr1}"
  end

  def context
  end

  def execute
    return @subexpr1
  end

  def get_width
    0
  end

  def get_height
    0
  end

end
