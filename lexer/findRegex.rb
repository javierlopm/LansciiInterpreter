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
        /read/,
        /write/,
        /\?/,
        /:/,
        /\[/,
        /]/,
        /\+/,
        /-/,
        /\*/,
        /\//,
        /\d+%\d+/,        #Creo que para que sea modulo debe tener digito antes y despues
        /true/,
        /false/,
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
        /$(<\[|\/\\\-_\ \]*>|#)/,        #Rotacion, no se si aceptar tambien un identificador...
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
        "TRUE",
        "FALSE",
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


    def initialize(myfile)
=begin  Hash? arreglo de 3 dimesiones?
        regexHash = {}
        new Array.new(TOKENNAME.length)
        
        0.upto(TOKENNAME.length) do |i|
            regexHash[i] = new Array.new(TOKENNAME.length)
            regexHash[i]
=end
        @myfile = myfile
        @mytokens = []
        @myerrors = []
        @line = 1
        @column = 1

    end

    def findAll

        while @myfile.empty? do
            # Expresion para ignorar los espacios en blanco y comentarios
            # REVISAR
            @myfile =~/\A(\s|\n|\{\-.*)*/
            self.skip($&)

            # Para cada elemento en la lista de tokens
            for i in 0.. @MAYBETOKEN.length.pred

                # Compara lo leido con el posible token
                @myfile =~ @MAYBETOKEN.at(i)

                # Si coincide 
                if $&
                    # Extrae la palabra
                    word = @input[0..($&.length.pred)]
                    self.skip($&)
                    # Crea el nuevo token
                    newtoken = Token.new(@TOKENNAME.at(i),@MAYBETOKEN.at(i),@line,@column)
                    # Guarda en la lista de tokens
                    @tokens << newtoken

                    break
                end

            end

            if $&
                next
            else
                # Si nunca coincidio, extrae la palabra
                @input =~ #NEW WORD FALTA EXPRESION REGULAR PARA AGARRAR LA PALABRA 
                self.skip($&)
                # Crea un nuevo error
                newerror = Error.new($&, @line, @column)
                # Guarda en la lista de errores
                @myerrors << newerror

                next
            end
        end 
    end

        # Metodo para correr el cursor
        def skip(word)

            # Quita la palabra leida
            @myfile = @myfile[word.length..@myfile.length]
            
            # FALTA ACTUALIZAR @line @column con el numero de columna 
            # y de linea al que se movio
        end
    end

    def printOutPut

        if @myerrors.length.eql?0
            @mytokens.each { |tok| 
                puts tok.to_s
            }
        else 
            @myerrors.each { |err| 
                puts err.to_s
            }
        end
    end
end
