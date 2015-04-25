# Javier Lopez 11-10552
# Patricia Reinoso 11-10851

# Clase para los token encontrados
class Token

    def initialize(name,value,line,column)
        @name = name
        @value = value
        @line = line
        @colum = column
    end

    def to_s
        "token #{@name} value (#{@value}) at line: #{@line}, column: #{@column}"
    end

end

class Error

    def initialize (value, line, column)
        @value = value
        @line = line
        @column = column
    end

    def to_s
        "Error: Unexpected character: \"#{@value}\" at line: #{@line}, column: #{@column}"
    end

end

class FindRegex

    @regexHash

    @MAYBETOKEN = [ 
        /\{(?!\-)/,
        /(?<!\-)\}/,
        /|/,
        /%/,            #Esta declaracion no debe tener ajuro un identificador despues?
        /!/,
        /@/,
        /=/,
        /;/,
        #/read/,
        #/write/,
        /\?/,
        /:/,
        /[/,
        /]/,
        /\+/,
        /-/,
        /\*/,
        /\//,
        /\d+%\d+/,        #Creo que para que sea modulo debe tener digito antes y despues
        #/true/,
        #/false/,
        /\/\\/,
        /\\\//,
        /^/,
        /</,
        /<=/,
        />/,
        />=/,
        /\/=/,
        #/<>/, #Expresion para lienzo
        #//,#Expresion para entero
        #//,#Expresion booleana
        /[a-zA-Z]\w*/, #Identificador
        /#/,
        /<.*\/.*>/,
        /<.*\\.*>/,
        /<.*\-.*>/,
        /<.*_.*>/,
        /'/,        #Transposicion              --Operador mas fuerte
        /$(<[|/\\\-_\ ]*>|#)/,        #Rotacion, no se si aceptar tambien un identificador...
        //,         #Concatenacion horizontal
        //,         #Concatenacion vertical
        /\{\-/,
        /\-\}/,
        /\.\./,
    ]

    @TOKENNAME = [
        "LCURLY",
        "RCURLY",
        "PIPE",
        "PERCENT",
        "EXCLAMATION MARK",
        "AT",
        "EQUALS",
        "SEMICOLON",
        "READ",
        "WRITE",
        "QUESTIONMARK",
        "COLON",
        "LSQUARE",
        "RSQUARE",
        "PLUS",
        "MINUS",
        "MULTIPLICATION SIGN",  #???
        "SLASH",                #???
        "MODULO",
        #"TRUE",
        #"FALSE",
        "AND",
        "OR",
        "NOT",
        "LESS",
        "LESSTHAN",
        "MORE",
        "MORETHAN",
        "NOTEQUALS",
        "IDENTIFIER",
        "EMPTY CANVAS",
        "CANVAS SLASH",
        "CANVAS BACKLASH",
        "CANVAS MINUS",
        "CANVAS UNDERSCORE",
        "TRANSPOSE",
        "ROTATION",
        "HORIZONTALCAT",    #???????
        "VERTICALCAT",      #???????
        "LCOMMENT",
        "RCOMMENT",
        "COMPREHENSION"     #??????
    ]

reserved = %w(read write true false)

    def initialize(args)
=begin  Hash? arreglo de 3 dimesiones?
        regexHash = {}
        new Array.new(TOKENNAME.length)
        
        0.upto(TOKENNAME.length) do |i|
            regexHash[i] = new Array.new(TOKENNAME.length)
            regexHash[i]
=end
    end

    def findAll(program)

    end
    
    
end
