=begin
    Separación en clases para las expresiones

    Javier Lopez     11-10552
    Patricia Reinoso 11-10851
=end

class Asign

	def initialize (identifier, subexpr1)

		@identifier = identifier
		@subexpr1 = subexpr1
	end
end


class Secuence

	def initialize (instrucion1, instrucion2)

		@instrucion1 = instrucion1
		@instrucion2 = instrucion2
	end
end

class Read

	def initialize (identifier)

		@identifier = identifier
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
end

class ExprSum < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "+"
		@type = 0
	end
end

class ExprSubs < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "-"
		@type = 0
	end
end

class ExpreMult < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "*"
		@type = 0
	end
end
	
class ExprDiv < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "/"
		@type = 0
	end
end
	
class ExprMod < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "%"
		@type = 0
	end
end
	
class ExprAnd < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "/\\"
		@type = 1
	end
end
	
class ExprOr < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "\/"
		@type = 1
	end
end
	
class ExprLess < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "<"
		@type = 1
	end
end
	
class ExprLessEql < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "<="
		@type = 1
	end
end
	
class ExprMore < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = ">"
		@type = 1
	end
end
	
class ExprMoreEql < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = ">="
		@type = 1
	end
end
	
class ExprEql < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "="
		@type = 1
	end
end
	
class ExprDiff < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "/="
		@type = 1
	end
end
	
class ExprVerConcat < BinExpr
	
	def initialize(subexpr1, subexpr2)

		@op = "&"
		@type = 2
	end
end
	
class ExprHorConcat < BinExpr

	def initialize(subexpr1, subexpr2)

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

