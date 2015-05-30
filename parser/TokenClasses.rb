=begin
    Separación en clases para las expresiones

    Javier Lopez     11-10552
    Patricia Reinoso 11-10851
=end

# puts "Estoy con #{val}";

=begin
class IdentList
	def initialize(identifier,list=nil)
		@identifier = identifier
		@list = list
	end

end
=end


def printLevel(level)

	
		
	for i in 0..level-1 do
    	$stdout.print " |  " #Believe in magic
	end 
	
end

class Asign

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
		puts "EXPRESION:"
		@subexpr1.print(level+2)
	end
end


class Secuence

	def initialize (instrucion1, instrucion2)

		@instrucion1 = instrucion1
		@instrucion2 = instrucion2
	end

	def print(level=0)

		printLevel(level)
		@instrucion1.print(level)
		@instrucion2.print(level)
	end
end

class Read

	def initialize (identifier)

		@identifier = identifier
	end

	def print(level=0)
		printLevel(level)
	end
end

class Write 

	def initialize (subexpr1)

		@subexpr1 = subexpr1
	end
end

class Conditional

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
end

class Conditional2 < Conditional

	def initialize (subexpr1, instrucion1, instrucion2)

		@subexpr1 = subexpr1
		@instrucion1 = instrucion1
		@instrucion2 = instrucion2
	end
end

class IIteration

	def initialize (subexpr1, instrucion1)
		
		@subexpr2 = subexpr2
		@instrucion1 = instrucion11
	end
end

class DIteration

	def initialize(subexpr1, subexpr2, instrucion1)

		@subexpr1 = subexpr1
		@subexpr2 = subexpr2
		@instrucion1 = instrucion1
		
	end
end

class DIteration2

	def initialize(identifier, subexpr1, subexpr2, instrucion1)

		@identifier = identifier
		@subexpr1 = subexpr1
		@subexpr2 = subexpr2
		@instrucion1 = instrucion1
	end
end


=begin 
type = 0 ==> Aritmetic 
type = 1 ==> Boolean
type = 2 ==> Canvas
type = 3 ==> Cualquier tipo

=end

# Expresiones binarias

class BinExpr

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

	def initialize(subexpr1, subexpr2)
		super
		@op = "+"
		@type = 0
	end
end

class ExprSubs < BinExpr

	def initialize(subexpr1, subexpr2)
		super
		@op = "-"
		@type = 0
	end
end

class ExprMult < BinExpr

	def initialize(subexpr1, subexpr2)
		super
		@op = "*"
		@type = 0
	end
end
	
class ExprDiv < BinExpr

	def initialize(subexpr1, subexpr2)
		super
		@op = "/"
		@type = 0
	end
end
	
class ExprMod < BinExpr

	def initialize(subexpr1, subexpr2)
		super
		@op = "%"
		@type = 0
	end
end
	
class ExprAnd < BinExpr

	def initialize(subexpr1, subexpr2)
		super
		@op = "/\\"
		@type = 1
	end
end
	
class ExprOr < BinExpr

	def initialize(subexpr1, subexpr2)
		super
		@op = "\\/"
		@type = 1
	end
end
	
class ExprLess < BinExpr

	def initialize(subexpr1, subexpr2)
		super
		@op = "<"
		@type = 1
	end
end
	
class ExprLessEql < BinExpr

	def initialize(subexpr1, subexpr2)
		super
		@op = "<="
		@type = 1
	end
end
	
class ExprMore < BinExpr

	def initialize(subexpr1, subexpr2)
		super
		@op = ">"
		@type = 1
	end


end
	
class ExprMoreEql < BinExpr

	def initialize(subexpr1, subexpr2)
		super
		@op = ">="
		@type = 1
	end
end
	
class ExprEql < BinExpr

	def initialize(subexpr1, subexpr2)
		super
		@op = "="
		@type = 1
	end
end
	
class ExprDiff < BinExpr

	def initialize(subexpr1, subexpr2)
		super
		@op = "/="
		@type = 1
	end
end
	
class ExprVerConcat < BinExpr
	
	def initialize(subexpr1, subexpr2)
		super
		@op = "&"
		@type = 2
	end
end
	
class ExprHorConcat < BinExpr

	def initialize(subexpr1, subexpr2)
		super
		@op = "~"
		@type = 2
	end
end
	

# Expresiones unarias

class UnExpr 
	def print
		puts "#{@op}"
	end
end


class ExprUnMinus < UnExpr

	def initialize(subexpr1)

		@op = "-"
		@type = 0
	end
end
	
class ExprNot < UnExpr

	def initialize(subexpr1)

		@op = "^"
		@type = 1
	end
end
	
class ExprTranspose < UnExpr

	def initialize(subexpr1)

		@op = "'"
		@type = 2
	end
end
	
# Expresiones constantes

class ExprParenthesis
	
	def initialize(subexpr1)

		@lp = "("
		@rp = ")"
		@subexpr1 = subexpr1
		@type = 3
	end
end
	
class ExprNumber

	def initialize(subexpr1)

		@subexpr1 = subexpr1
		@type = 0
	end

	def print(level=0)
		printLevel(level)
		puts "NUMBER: #{@subexpr1}"
	end
end
	
class ExprTrue

	def initialize()

		@subexpr1 = "true"
		@type = 1
	end
end
	
class ExprFalse

	def initialize()

		@subexpr1 = "false"
		@type = 1
	end
end
	
class ExprId

	def initialize(identifier)

		@subexpr1 = identifier
		@type = 3
	end

	def print(level=0)
		printLevel(level)
		puts "IDENTIFIER: #{@subexpr1}"
	end
end
	
class ExprCanvas

	def initialize(canvas)

		@subexpr1 = canvas
		@type = 3
	end
end
	
class ExprEmptyCanvas

	def initialize()

		@subexpr1 = "#"
		@type = 2
	end
end

