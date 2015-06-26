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
    type = '\'%\''
  when 1
    type = '\'!\''
  when 2
    type = '\'@\''
  else
    type = 'not declared variable'
  end
  return type
end

def is32bits?(number)
    return (number < 2**31 and number >= -2**31)
end

class Undeclared

  def initialize(identifier)
    @identifier = identifier
  end

  def to_s
    "Error: variable '#{@identifier}' does not exist in this block"
  end
end

class AsignError

  def initialize(identifier, type1, type2)

    @identifier = identifier
    @type1 = Get_Type(type1)
    @type2 = Get_Type(type2)
  end

  def to_s
    "Error: Lanscii is trying to asign type #{@type2} to the variable '#{@identifier}' of type #{@type1}"
  end
end

class ConditionalError

  def initialize(type1)

    @type1 = Get_Type(type1)
  end

  def to_s
    "Error: conditional instruction expected type '!' but received #{@type1}"
  end
end

class IIterationError
  def initialize(type1)

    @type1 = Get_Type(type1)
  end

  def to_s
    "Error: iteration instruction expected type '!' but received #{@type1}"
  end
end

class DIterationError
  def initialize(type1)

    @type1 = Get_Type(type1)
  end

  def to_s
    "Error: iteration limit expected '%' but received #{@type1}"
  end
end

class DIteration2Error
  def initialize(type1)

    @type1 = Get_Type(type1)
  end

  def to_s
    "Error: iteration variable expected '%' but received #{@type1}"
  end
end


class TypeError

  def initialize(op, type1, type2)
    @op = op
    @type1 = Get_Type(type1)
    @type2 = Get_Type(type2)
  end

  def to_s
    "Error: Lanscii is trying to do the operation '#{@op}' between #{@type1} and #{@type2}"
  end
end

class UnaryError

  def initialize(op, type1, type2)
    @op = op
    @type1 = Get_Type(type1)
    @type2 = Get_Type(type2)
  end

  def to_s
    "Error: operator '#{@op}' does not work with operands #{@type1} and #{@type2}"
  end
end

class ReadError

  def initialize(type1)
    @type1 = Get_Type(type1)
  end

  def to_s
    "Error: operation 'read' expected type '%' or '!' but received #{@type1}"
  end
end



class WriteError

  def initialize(type1)
    @type1 = Get_Type(type1)
  end

  def to_s
    "Error: operation 'write' expected type '@' but received #{@type1}"
  end
end

class ReDeclare

  def initialize(identifier)
    @identifier = identifier
  end

  def to_s
    "Error: variable '#{@identifier}' is already declared"
  end
end

class NotModifiable

  def initialize(identifier)
    @identifier = identifier
  end

  def to_s
    "Error: variable '#{@identifier}' must not be modified"
  end
end


#################################################
##                Errores Dinamicos            ##
#################################################

class DynamicReadError
  def initialize(msg)
    @msg = msg
  end

  def to_s
    "Error: Lanscii is trying to read " + @msg
  end
end

class NotMatchingWidth
  def initialize(name1,name2,width1,width2,height1,height2)
    @name1   = name1
    @name2   = name2
    @height1 = height1
    @height2 = height2
    @width1  = width1
    @width2  = width2
  end

  def to_s
    er  = "Error: Lanscii is trying to do vertical concat with incompatible"
    er += " canvas (#{@name1}: #{@height1}*#{@width1},"
    er +=          "#{@name2}: #{@height2}*#{@width2})"
  end
end

class DivCero

  def initialize(subexpr1)
    @subexpr1 = subexpr1
  end

  def to_s
    "Error: Lanscii is trying to divide by cero"
  end

end

class Overflow

  def initialize(op)
    @op = op
  end

  def to_s
    "Error: overflow found in operation '#{@op}'"
  end

end

class NotInitialize

  def initialize(identifier)
    @identifier = identifier
  end

  def to_s
    "Error: Lanscii is trying to evaluate not initialize variable '#{@identifier}'"
  end
end

class CanvasConcat

  def initialize(subexpr1, subexpr2, op)
    @subexpr1 = subexpr1
    @subexpr2 = subexpr2
    @op = op
  end

  def to_s
    "Error: #{@op} uncampatible canvas (#{@subexpr1}, #{@subexpr2})"
  end
end

