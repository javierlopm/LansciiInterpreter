=begin
    Implementacion de lexer en ruby para la 

    Javier Lopez     11-10552
    Patricia Reinoso 11-10851
=end
# Clase para los token encontrados
class Token

    def initialize(name,value,line,column)
        @name   = name
        @line   = line
        @column = column

        if mustStrip?value
            @value = value[1..(palabra.length-2)]
        else
            @value = value
        end

    end

    #Funcion para verificar si el token encontrado puede ser divido
    def mustStrip?(word)
        # res = (word ~= /\(.*\)/).eql?0 No se si hay que repetir mismo caso con los parentesis
        res = (word =~ /<.*>/).eql?0
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

    def initialize(myFile)
        @MAYBETOKEN = [ 
            /\{/,
            /\}/,
            /\|/,
            /\%/,            #Esta declaracion no debe tener ajuro un identificador despues?
            /\!/,
            /\@/,
            /\=/,
            /\;/,
            /read/,
            /write/,
            /\?/,
            /\:/,
            /\[/,
            /\]/,
            /\(/,
            /\)/,
            /\+/,
            /\-/,
            /\*/,
            /\//,
            /\d+%\d+/,        #Creo que para que sea modulo debe tener digito antes y despues
            /true/,
            /false/,
            /\/\\/,
            /\\\//,
            /\^/,
            /\</,
            /\<=/,
            /\>/,
            /\>=/,
            /\/=/,
            /[a-zA-Z]\w*/, #Identificador
            /\d{1,10}/,    #Cambiar por expresion real
            /\#/,
            /<([\/\\\|\_\-\ ])*>/,         
            /\'/,        #Transposicion              --Operador mas fuerte
            /\$/,        #Rotacion, no se si aceptar tambien un identificador...
            # /:/,         #Concatenacion horizontal hay que diferenciarlas de pipe y colon
            # /\|/,        #Concatenacion vertical
            /\{\-/,
            /\-\}/,
            /\.\./,
            /./    #No se encontro nada, match de un caracter con lo que sea
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
            "LPARENTHESIS",
            "RPARENTHESIS",
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
            "NUMBER",
            "EMPTY CANVAS",
            "CANVAS",
            "TRANSPOSE",
            "ROTATION",
            # "HORIZONTALCAT",    #??????? Falta definirlos
            # "VERTICALCAT",      #???????
            "LCOMMENT",
            "RCOMMENT",
            "COMPREHENSION",     #??????
            "404"
        ]
        
        @myFile     = myFile
        @myTokens = []
        @myErrors = []
        @line     = 1
        @column   = 1

    end

    def findAll

        while !@myFile.empty? do
            # Expresion para ignorar los espacios en blanco y comentarios
            # REVISAR
            # puts @myFile.length
            
            # @myFile =~ /(\A(\s|#.*)*)/m #Elimine' |\n 
            @myFile =~ /\A(\ |\s|{-.*-})*/ #Extraccion de espacios, saltos de linea y comentarios
    
            self.skip($&)
            
            # Para cada elemento en la lista de tokens
            for i in 0..@MAYBETOKEN.length.pred

                # Compara lo leido con el posible token
                @myFile =~ /\A#{@MAYBETOKEN.at(i)}/

                
                # Si coincide
                if $&
                    # Extrae la palabra
                    word = @myFile[0,($&.length)]
                    
                    # Verifica si el elemento encotrado era valido
                    if @TOKENNAME.at(i).eql?"404"
                        # Crea error en caso de haber llegado al final
                        errorFound = Error.new(word,@line,@column)
                        @myErrors << errorFound
                    else
                        # Crea un token en caso valido
                        newtoken = Token.new(@TOKENNAME.at(i),word,@line,@column)
                        @myTokens << newtoken
                    end
                    
                    self.skip(word)

                    

                    break
                end

            end

            break if @myFile.empty?

=begin
            if $&
                puts ""
            else
                # Si nunca coincidio, extrae la palabra
                @myFile =~ /\A(\w|\p{punct})*/m#NEW WORD FALTA EXPRESION REGULAR PARA AGARRAR LA PALABRA 
                
                word = $&[0,1]
                # puts "abajo"
                # puts $&
                #self.skip(word)
                # Crea un nuevo error
                newerror = Error.new(word, @line, @column)
                # Guarda en la lista de errores
                @myErrors << newerror
            end
=end
        end 
    end

    # Metodo para correr el cursor 
    def skip(word)

        # Quita la palabra leida
        unless word.nil?
            word.each_char do |c|   #Never use .each_byte jejeps
                if c.eql?"\n"
                    @line    +=1 
                    @column   =1
                else
                    @column  +=1
                end
            end
            
            @myFile = @myFile[word.length..@myFile.length]
        end
        #puts @myFile
        # FALTA ACTUALIZAR @line @column con el numero de columna 
        # y de linea al que se movio
    end

    def printOutPut

        if @myErrors.length.eql?0
            @myTokens.each { |tok| 
                puts tok.to_s
            }
        else 
            @myErrors.each { |err| 
                puts err.to_s
            }
        end
    end
end
