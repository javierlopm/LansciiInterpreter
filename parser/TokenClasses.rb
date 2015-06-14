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

	attr_accessor :instrucion1
  	attr_accessor :symbolTable

	def initialize (instrucion1,symbolTable=nil)
		@instrucion1 = instrucion1
		@symbolTable = symbolTable
		@instrucion1.add_symbols(symbolTable)
	end

	def context()
		@instrucion1.context()
	end
end


class Asign < SymbolUser

	attr_accessor :identifier
	attr_accessor :subexpr1

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

	def context()

		symboltype = @symbolTable.lookup(@identifier)
		if symboltype.nil? then 
			# Error: No declarado
			@symbolTable.errors << Undeclared::new(@identifier)
		else
			@subexpr1.context()
			unless symboltype.eql? @subexpr1.type then
				# Error: Tipo
				@symbolTable.errors << AsignError::new(@identifier,symboltype,@subexpr1.type)
			end
		end
	end

end

class Secuence < SymbolUser

  	attr_accessor :instrucion1
  	attr_accessor :instrucion2

	def initialize (instrucion1, instrucion2)

		@instrucion1 = instrucion1
		@instrucion2 = instrucion2
	end

	def print(level=0)
		@instrucion1.print(level)
		@instrucion2.print(level)
	end

	def context()
		@instrucion1.context()
		@instrucion2.context()
	end
end

class Read < SymbolUser

	attr_accessor :identifier

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

	def context()
		
		symboltype = @symbolTable.lookup(@identifier)
		if symboltype.nil? then 
			# Error: No declarado
			@symbolTable.errors << Undeclared::new(@identifier)
		else
			if symboltype.eql?2 then
				# Error: Tipo
				@symbolTable.errors << ReadError::new(@identifier,@subexpr1.type)
			end
		end
	end

end

class Write < SymbolUser

	attr_accessor :subexpr1

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

	def context()

		@subexpr1.context()

		unless @subexpr1.type.eql?2 then
			#ERROR: debe ser Canvas
			@symbolTable << WriteError::new(@subexpr1.type)
		end
end

class Conditional < SymbolUser

	attr_accessor :subexpr1
	attr_accessor :instrucion1

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

	def context()

		@subexpr1.context()

		unless @subexpr1.type.eql? 1 then
			# Error: Debe ser de tipo booleano
			@symbolTable << ConditionalError::new(@subexpr1.type)
		end
		@instrucion1.context()

	end
end

class Conditional2 < Conditional

  	attr_accessor :subexpr1
	attr_accessor :instrucion1
  	attr_accessor :instrucion2

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


	def context()

		@subexpr1.context()

		unless @subexpr1.type.eql? 1 then
			# Error: Debe ser de tipo booleano
			@symbolTable << ConditionalError::new(@subexpr1.type)
		end
		@instrucion1.context()
		@instrucion2.context()
	end
end

class IIteration < SymbolUser

  	attr_accessor :subexpr1
  	attr_accessor :instrucion1

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

	def context()

		@subexpr1.context()
	
		unless @subexpr1.type.eql?1 then
			@symbolTable.errors << IIterationError::new(@subexpr1.type)
		end
		@instrucion1.context()
	end

end

class DIteration < SymbolUser

	attr_accessor :subexpr1
	attr_accessor :subexpr2
  	attr_accessor :instrucion1

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

	def context()

		@subexpr1.context()
		@subexpr2.context()

		unless @subexpr1.type.eql?0 then
			@symbolTable.errors << DIterationError::new(@subexpr1.type)
		end
		unless @subexpr2.type.eql?0 then
			@symbolTable.errors << DIterationError::new(@subexpr2.type)
		end

		@instrucion1.context()
	end

end

class DIteration2 < SymbolUser

	attr_accessor :identifier
  	attr_accessor :subexpr1
	attr_accessor :subexpr2
  	attr_accessor :instrucion1

	def initialize(identifier, subexpr1, subexpr2, instrucion1)

		@identifier  = identifier
		@subexpr1    = subexpr1
		@subexpr2    = subexpr2
		@instrucion1 = instrucion1
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

	def context()

		symboltype = @symbolTable.lookup(@identifier)
		if symboltype.nil? then 
			# Error: No declarado
			@symbolTable.errors << Undeclared::new(@identifier)
		end
		unless symboltype.eql?0 then
			# Error: La variable debe ser del tipo entero
			@symbolTable.errors << DIteration2Error::new(symboltype)
		end

		@subexpr1.context()
		@subexpr2.context()

		unless @subexpr1.type.eql?0 then
			@symbolTable.errors << DIterationError::new(@subexpr1.type)
		end
		unless @subexpr2.type.eql?0 then
			@symbolTable.errors << DIterationError::new(@subexpr2.type)
		end

		@instrucion1.context()
	end
end

class VarBlock < SymbolUser

	attr_accessor :symbolTable
  	attr_accessor :instrucion1

	def initialize(symbolTable,instrucion1)
		@symbolTable = symbolTable
		@instrucion1 = instrucion1
	end

	def add_symbols(symbolTable)
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

	def context()
		@instrucion1.context()
	end

end

class Block < SymbolUser

	attr_accessor :instrucion1

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

	def context()
		@instrucion1.context()
	end
end


=begin
@type indica el tipo de la salida
type = 0 ==> Aritmetic 
type = 1 ==> Boolean
type = 2 ==> Canvas
type = 3 ==> Cualquier tipo
=end

# Expresiones binarias

class BinExpr < SymbolUser

	attr_accessor :subexpr1
  	attr_accessor :subexpr2

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

	attr_accessor :op
  	attr_accessor :type

	def initialize(subexpr1, subexpr2)
		super
		@op = "+"
		@type = 0
	end

	def context ()
		@subexpr1.context()
		@subexpr2.context()

		unless @type.eql? @subexpr1.type and @type.eql? @subexpr2.type then
			# ERROR: debe ser entero
			@symbolTable.errors << TypeError::new(@op, @subexpr1.type, @subexpr2.type)
		end

	end
end

class ExprSubs < BinExpr
	
	attr_accessor :op
  	attr_accessor :type

	def initialize(subexpr1, subexpr2)
		super
		@op = "-"
		@type = 0
	end

	def context ()
		@subexpr1.context()
		@subexpr2.context()

		unless @type.eql? @subexpr1.type and @type.eql? @subexpr2.type then
			# ERROR: debe ser entero
			@symbolTable.errors << TypeError::new(@op, @subexpr1.type, @subexpr2.type)
		end
	end

end

class ExprMult < BinExpr

	attr_accessor :op
  	attr_accessor :type

	def initialize(subexpr1, subexpr2)
		super
		@op = "*"
		@type = 0
	end

	def context ()
		@subexpr1.context()
		@subexpr2.context()

		unless @type.eql? @subexpr1.type and @type.eql? @subexpr2.type then
			# ERROR: debe ser entero
			@symbolTable.errors << TypeError::new(@op, @subexpr1.type, @subexpr2.type)
		end
	end
end
	
class ExprDiv < BinExpr
	
	attr_accessor :op
  	attr_accessor :type

	def initialize(subexpr1, subexpr2)
		super
		@op = "/"
		@type = 0
	end

	def context ()
		@subexpr1.context()
		@subexpr2.context()

		unless @type.eql? @subexpr1.type and @type.eql? @subexpr2.type then
			# ERROR: debe ser entero
			@symbolTable.errors << TypeError::new(@op, @subexpr1.type, @subexpr2.type)
		end
	end
end
	
class ExprMod < BinExpr

	attr_accessor :op
  	attr_accessor :type
	
	def initialize(subexpr1, subexpr2)
		super
		@op = "%"
		@type = 0
	end

	def context ()
		@subexpr1.context()
		@subexpr2.context()

		unless @type.eql? @subexpr1.type and @type.eql? @subexpr2.type then
			# ERROR: debe ser entero
			@symbolTable.errors << TypeError::new(@op, @subexpr1.type, @subexpr2.type)
		end
	end
end
	
class ExprAnd < BinExpr

	attr_accessor :op
  	attr_accessor :type

	def initialize(subexpr1, subexpr2)
		super
		@op = "/\\"
		@type = 1
	end

	def context ()
		@subexpr1.context()
		@subexpr2.context()

		unless @type.eql? @subexpr1.type and @type.eql? @subexpr2.type then
			# ERROR: debe ser booleano
			@symbolTable.errors << TypeError::new(@op, @subexpr1.type, @subexpr2.type)
		end

	end
end
	
class ExprOr < BinExpr

	attr_accessor :op
  	attr_accessor :type

	def initialize(subexpr1, subexpr2)
		super
		@op = "\\/"
		@type = 1
	end

	def context ()
		@subexpr1.context()
		@subexpr2.context()

		unless @type.eql? @subexpr1.type and @type.eql? @subexpr2.type then
			# ERROR: debe ser booleano
			@symbolTable.errors << TypeError::new(@op, @subexpr1.type, @subexpr2.type)
		end
	end

end
	
class ExprLess < BinExpr

	attr_accessor :op
  	attr_accessor :type

	def initialize(subexpr1, subexpr2)
		super
		@op = "<"
		@type = 1
	end


	def context ()
		@subexpr1.context()
		@subexpr2.context()

		unless @subexpr1.type.eql?0 and @subexpr2.type.eql?0 then
			# ERROR: debe ser entero
			@symbolTable.errors << TypeError::new(@op, @subexpr1.type, @subexpr2.type)
		end
	end
end
	
class ExprLessEql < BinExpr
	
	attr_accessor :op
  	attr_accessor :type

	def initialize(subexpr1, subexpr2)
		super
		@op = "<="
		@type = 1
	end

	def context ()
		@subexpr1.context()
		@subexpr2.context()

		unless @subexpr1.type.eql?0 and @subexpr2.type.eql?0 then
			# ERROR: debe ser entero
			@symbolTable.errors << TypeError::new(@op, @subexpr1.type, @subexpr2.type)
		end
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
		@subexpr1.context()
		@subexpr2.context()

		unless @subexpr1.type.eql?0 and @subexpr2.type.eql?0 then
			# ERROR: debe ser entero
			@symbolTable.errors << TypeError::new(@op, @subexpr1.type, @subexpr2.type)
		end
	end
end
	
class ExprMoreEql < BinExpr

	attr_accessor :op
  	attr_accessor :type

	def initialize(subexpr1, subexpr2)
		super
		@op = ">="
		@type = 1
	end


	def context ()
		@subexpr1.context()
		@subexpr2.context()

		unless @subexpr1.type.eql?0 and @subexpr2.type.eql?0 then
			# ERROR: debe ser entero
			@symbolTable.errors << TypeError::new(@op, @subexpr1.type, @subexpr2.type)
		end
	end
end
	
class ExprEql < BinExpr

	attr_accessor :op
  	attr_accessor :type

	def initialize(subexpr1, subexpr2)
		super
		@op = "="
		@type = 1
	end


	def context ()
		@subexpr1.context()
		@subexpr2.context()

		unless @subexpr1.type.eql?@subexpr2.type then
			# ERROR: debe ser del mismo tipo
			@symbolTable.errors << TypeError::new(@op, @subexpr1.type, @subexpr2.type)
		end
	end
end
	
class ExprDiff < BinExpr

	attr_accessor :op
  	attr_accessor :type

	def initialize(subexpr1, subexpr2)
		super
		@op = "/="
		@type = 1
	end

	def context ()
		@subexpr1.context()
		@subexpr2.context()

		unless @subexpr1.type.eql?@subexpr2.type then
			# ERROR: debe ser del mismo tipo
			@symbolTable.errors << TypeError::new(@op, @subexpr1.type, @subexpr2.type)
		end

	end
end
	
class ExprVerConcat < BinExpr
	
	attr_accessor :op
  	attr_accessor :type

	def initialize(subexpr1, subexpr2)
		super
		@op = "&"
		@type = 2
	end

	def context ()
		@subexpr1.context()
		@subexpr2.context()

		unless @type.eql?@subexpr1.type and @type.eql?@subexpr2.type then
			# ERROR: debe ser canvas
			@symbolTable.errors << TypeError::new(@op, @subexpr1.type, @subexpr2.type)
		end

	end

end
	
class ExprHorConcat < BinExpr

	attr_accessor :op
  	attr_accessor :type

	def initialize(subexpr1, subexpr2)
		super
		@op = "~"
		@type = 2
	end

	def context ()
		@subexpr1.context()
		@subexpr2.context()

		unless @type.eql?@subexpr1.type and @type.eql?@subexpr2.type then
			# ERROR: debe ser canvas
			@symbolTable.errors << TypeError::new(@op, @subexpr1.type, @subexpr2.type)
		end

	end
end
	

# Expresiones unarias

class UnExpr < SymbolUser

  	attr_accessor :subexpr1

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

	attr_accessor :op
  	attr_accessor :type

	def initialize(subexpr1)
		super
		@op = "-"
		@type = 0
	end

	def context()
		@subexpr1.context()

		unless @type.eql? @subexpr1.type then
			@symbolTable.errors << UnaryError::new(@op,1,2)
			
		end
		
	end
end
	
class ExprNot < UnExpr

	attr_accessor :op
  	attr_accessor :type
	
	def initialize(subexpr1)

		super
		@op = "^"
		@type = 1
	end

	def context()
		@subexpr1.context()

		unless @type.eql? @subexpr1.type then
			@symbolTable.errors << UnaryError::new(@op,0,2)
			
		end
		
	end
end
	
class ExprTranspose < UnExpr

	attr_accessor :op
  	attr_accessor :type

	def initialize(subexpr1)
		
		super
		@op = "'"
		@type = 2
	end

	def context()
		@subexpr1.context()

		unless @type.eql? @subexpr1.type @type then
			@symbolTable.errors << UnaryError::new(@op,0,1)
			
		end
		
	end
end
	
# Expresiones constantes

class ExprParenthesis < SymbolUser

	attr_accessor :subexpr1
  	attr_accessor :type

	def initialize(subexpr1)

		@lp = "("
		@rp = ")"
		@subexpr1 = subexpr1
		@type = 3
	end

	def context()
		@subexpr1.context()
		
		if @type.eql?3 then
			@type = @subexpr1.type
		end

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

	def context();end
end



class ExprTrue < Constant

	attr_accessor :subexpr1
  	attr_accessor :type

	def initialize()

		@subexpr1 = "true"
		@type = 1
	end

	def print(level=0)
		printLevel(level)
		puts "BOOL: #{@subexpr1}"
	end

	def context();end
end
	
class ExprFalse < Constant

	attr_accessor :subexpr1
  	attr_accessor :type

	def initialize()

		@subexpr1 = "false"
		@type = 1
	end

	def print(level=0)
		printLevel(level)
		puts "BOOL: #{@subexpr1}"
	end

	def context();end
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

	def context()

		symboltype = @symbolTable.lookup(@identifier)
		if symboltype.nil? then 
			# Error: No declarado
			@symbolTable.errors << Undeclared::new(@identifier)
		else
			if @type.eql?3 then
				@type = symboltype
			end
		end
	end

end
	
class ExprCanvas < Constant

	attr_accessor :subexpr1
  	attr_accessor :type

	def initialize(canvas)

		@subexpr1 = canvas
		@type = 2
	end

	def print(level=0)
		printLevel(level)
		puts "CANVAS: #{@subexpr1}"
	end

	def context();end
end
	
class ExprEmptyCanvas < Constant

	attr_accessor :subexpr1
  	attr_accessor :type

	def initialize()

		@subexpr1 = "#"
		@type = 2
	end

	def print(level=0)
		printLevel(level)
		puts "CANVAS: #{@subexpr1}"
	end

	def context();end
end

