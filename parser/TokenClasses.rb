=begin
    Separación en clases para las expresiones

    Javier Lopez     11-10552
    Patricia Reinoso 11-10851
=end

=begin 
type = 0 ==> Aritmetic 
type = 1 ==> Boolean
type = 2 ==> Canvas

=end
class BinExpr


class ExprSum

	def initialize(subexpr1, subexpr2)

	@subexpr1 = subexpr1
	@subexpr2 = subexpr2
	@op = "+"
	@type = 0

class ExprSubs

	def initialize(subexpr1, subexpr2)

	@subexpr1 = subexpr1
	@subexpr2 = subexpr2
	@op = "-"
	@type = 0

class ExpreMult

	def initialize(subexpr1, subexpr2)

	@subexpr1 = subexpr1
	@subexpr2 = subexpr2
	@op = "*"
	@type = 0

class ExprDiv

	def initialize(subexpr1, subexpr2)

	@subexpr1 = subexpr1
	@subexpr2 = subexpr2
	@op = "/"
	@type = 0

class ExprMod

	def initialize(subexpr1, subexpr2)

	@subexpr1 = subexpr1
	@subexpr2 = subexpr2
	@op = "%"
	@type = 0

class ExprAnd

	def initialize(subexpr1, subexpr2)

	@subexpr1 = subexpr1
	@subexpr2 = subexpr2
	@op = "/\\"
	@type = 1


class ExprOr

	def initialize(subexpr1, subexpr2)

	@subexpr1 = subexpr1
	@subexpr2 = subexpr2
	@op = "\/"
	@type = 1

class ExprLess

	def initialize(subexpr1, subexpr2)

	@subexpr1 = subexpr1
	@subexpr2 = subexpr2
	@op = "<"
	@type = 1

class ExprLessEql

	def initialize(subexpr1, subexpr2)

	@subexpr1 = subexpr1
	@subexpr2 = subexpr2
	@op = "<="
	@type = 1

class ExprMore

	def initialize(subexpr1, subexpr2)

	@subexpr1 = subexpr1
	@subexpr2 = subexpr2
	@op = ">"
	@type = 1

class ExprMoreEql

	def initialize(subexpr1, subexpr2)

	@subexpr1 = subexpr1
	@subexpr2 = subexpr2
	@op = ">="
	@type = 1

class ExprEql

	def initialize(subexpr1, subexpr2)

	@subexpr1 = subexpr1
	@subexpr2 = subexpr2
	@op = "="
	@type = 1

class ExprDiff

	def initialize(subexpr1, subexpr2)

	@subexpr1 = subexpr1
	@subexpr2 = subexpr2
	@op = "/="
	@type = 1

class ExprVerConcat
	
	def initialize(subexpr1, subexpr2)

	@subexpr1 = subexpr1
	@subexpr2 = subexpr2
	@op = "&"
	@type = 2

class ExprHorConcat

	def initialize(subexpr1, subexpr2)

	@subexpr1 = subexpr1
	@subexpr2 = subexpr2
	@op = "~"
	@type = 2
















