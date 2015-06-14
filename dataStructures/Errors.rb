=begin
@type indica el tipo de la salida
type = 0 ==> Aritmetic %
type = 1 ==> Boolean !
type = 2 ==> Canvas @
type = 3 ==> Cualquier tipo
=end
def Get_Type(code)

    case code
      when 0
        type = '%'
      when 1
        type = '!'
      when 2
        type = '@'
      else 3
        type = nil
    end
    return type
end

class Undeclared

	def initialize(identifier)
		@identifier = identifier	
	end

	def to_s
		"Error: variable '#{@identifier}' no existe dentro de este alcance"
	end
end

class AsignError

	def initialize(identifier, type1, type2)

		@identifier = identifier
		@type1 = Get_Type(type1)
		@type2 = Get_Type(type2)
	end

	def to_s
		"Error: se intenta asignar el tipo '#{@type2}'' a la varialbe '#{@identifier}' de tipo '#{@type1}'"
	end
end

class ConditionalError

	def initialize(type1)

		@type1 = Get_Type(type1)
	end

	def to_s
		"Error: instrucción condicional espera tipo '!' y obtuvo '#{@type1}'"
	end
end

class IIterationError
	def initialize(type1)

		@type1 = Get_Type(type1)
	end

	def to_s
		"Error: instrucción de iteración espera tipo '!' y obtuvo '#{@type1}'"
	end
end

class DIterationError
	def initialize(type1)

		@type1 = Get_Type(type1)
	end

	def to_s
		"Error: límite de iteración espera tipo '%' y obtuvo '#{@type1}'"
	end
end

class DIteration2Error
	def initialize(type1)

		@type1 = Get_Type(type1)
	end

	def to_s
		"Error: variable de iteración espera tipo '%' y obtuvo '#{@type1}'"
	end
end


class TypeError 

	def initialize(op, type1, type2)
		@op = op
		@type1 = Get_Type(type1)
		@type2 = Get_Type(type2)
	end

	def to_s
		"Error: se intenta hacer la operación '#{@op}' entre '#{@type1}' y '#{@type2}'"
	end
end

class UnaryError 

	def initialize(op, type1, type2)
		@op = op
		@type1 = Get_Type(type1)
		@type2 = Get_Type(type2)
	end

	def to_s
		"Error: operador '#{@op}' no funciona con operandos '#{@type1}' y '#{@type2}'"
	end
end

class ReadError

	def initialize(type1)
		@type1 = Get_Type(type1)
	end

	def to_s
		"Error: operación 'read' espera el tipo '%' o '!' y obtuvo '#{@type1}'"
	end
end

class WriteError

	def initialize(type1)
		@type1 = Get_Type(type1)
	end

	def to_s
		"Error: operación 'write' espera el tipo '@' y obtuvo '#{@type1}'"
	end
end

class ReDeclare

	def initialize(identifier)
		@identifier = identifier
	end

	def to_s 
		"Error: la variable '#{@identifier}' ya está declarada"
	end
end
