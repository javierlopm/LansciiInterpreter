=begin
    Separación en clases para las expresiones

    Javier Lopez     11-10552
    Patricia Reinoso 11-10851
=end

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

class ExprSum < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "+"
		@type = 0

class ExprSubs < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "-"
		@type = 0

class ExpreMult < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "*"
		@type = 0

class ExprDiv < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "/"
		@type = 0

class ExprMod < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "%"
		@type = 0

class ExprAnd < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "/\\"
		@type = 1

class ExprOr < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "\/"
		@type = 1

class ExprLess < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "<"
		@type = 1

class ExprLessEql < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "<="
		@type = 1

class ExprMore < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = ">"
		@type = 1

class ExprMoreEql < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = ">="
		@type = 1

class ExprEql < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "="
		@type = 1

class ExprDiff < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "/="
		@type = 1

class ExprVerConcat < BinExpr
	
	def initialize(subexpr1, subexpr2)

		@op = "&"
		@type = 2

class ExprHorConcat < BinExpr

	def initialize(subexpr1, subexpr2)

		@op = "~"
		@type = 2


# Expresiones unarias

class UnExpr 

class ExprUnMinus < UnExpr

	def initialize(subexpr1)

		@op = "-"
		@type = 0

class ExprNot < UnExpr

	def initialize(subexpr1)

		@op = "^"
		@type = 1

class ExprTranspose < UnExpr

	def initialize(subexpr1)

		@op = "'"
		@type = 2

# Expresiones constantes

class ExprParenthesis
	
	def initialize(subexpr1)

		@lp = "("
		@rp = ")"
		@subexpr1 = subexpr1
		@type = 3

class ExprNumber

	def initialize(subexpr1)

		@subexpr1 = subexpr1
		@type = 0

class ExprTrue

	def initialize()

		@subexpr1 = "true"
		@type = 1

class ExprFalse

	def initialize()

		@subexpr1 = "false"
		@type = 1

class ExprId

	def initialize(identifier)

		@subexpr1 = identifier
		@type = 3

class ExprCanvas

	def initialize(canvas)

		@subexpr1 = canvas
		@type = 3

class ExprEmptyCanvas

	def initialize()

		@subexpr1 = "#"
		@type = 2



























