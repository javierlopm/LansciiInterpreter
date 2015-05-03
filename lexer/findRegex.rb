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
            @value = value[1..(value.length-2)]
        elsif extraSpace?value
            @value = value[0..(value.length-2)]
        else
            @value = value
        end

    end

    #Funcion para verificar si el token encontrado debe ser divido
    def mustStrip?(word)
        res = (word =~ /<.*>/).eql?0
    end

    #Función para eliminar el espacio extra en el valor de read y write
    def extraSpace?(word)
        res = word[word.length-1].eql?" "
    end

    def to_s
        "token #{@name} value (#{@value}) at line: #{@line}, column: #{@column}"
    end

end


class Error

    def initialize (value, line, column, type)
        @value  = value
        @line   = line
        @column = column
        @type   = type
    end

    def to_s

        msg = "Error: "

        case @type
        when "UNEXPECTED"
            msg += "Unexpected character: \"#{@value}\""
        when "MULTICLOSE"
            msg += "Comment section closed more than once"
        when "BADOPEN"
            msg += "Comment section opened but not closed"
        when "BADCLOSE"
            msg += "Comment section closed but not opened"        
        when "OVERFLOW"
            msg += "Integer constant overflow"
        end

        msg  += " at line: #{@line}, column: #{@column}"
    end

end

class FindRegex

    def initialize(myFile)

        #Arreglo de hashes con expr. regulares y nombres de token asociados
        @MAYBETOKEN = [ 
            {:regex=>/\{/,          :name=>"LCURLY"             },
            {:regex=>/\}/,          :name=>"RCURLY"             },
            {:regex=>/\|/,          :name=>"PIPE"               },
            {:regex=>/\%/,          :name=>"PERCENT"            },
            {:regex=>/\!/,          :name=>"EXCLAMATION MARK"   },
            {:regex=>/\@/,          :name=>"AT"                 },
            {:regex=>/\=/,          :name=>"EQUALS"             },
            {:regex=>/\;/,          :name=>"SEMICOLON"          },
            {:regex=>/read /,       :name=>"READ"               },
            {:regex=>/write /,      :name=>"WRITE"              },
            {:regex=>/\?/,          :name=>"QUESTIONMARK"       },
            {:regex=>/\:/,          :name=>"COLON"              },
            {:regex=>/\[/,          :name=>"LSQUARE"            },
            {:regex=>/\]/,          :name=>"RSQUARE"            },
            {:regex=>/\(/,          :name=>"LPARENTHESIS"       },
            {:regex=>/\)/,          :name=>"RPARENTHESIS"       },
            {:regex=>/true/,        :name=>"TRUE"               },
            {:regex=>/false/,       :name=>"FALSE"              },
            {:regex=>/\/\\backslash{}/,       :name=>"AND"      },
            {:regex=>/\\backslash{}\//,       :name=>"OR"       },
            {:regex=>/<(\/|\\|\||\_|\-|\ )*>/,:name=>"CANVAS"   },
            {:regex=>/\^/,          :name=>"NOT"                },
            {:regex=>/\<=/,         :name=>"LESSTHAN"           },
            {:regex=>/\>=/,         :name=>"MORETHAN"           },
            {:regex=>/\/=/,         :name=>"NOTEQUALS"          },
            {:regex=>/\</,          :name=>"LESS"               },
            {:regex=>/\>/,          :name=>"MORE"               },
            {:regex=>/\+/,          :name=>"PLUS"               },
            {:regex=>/\-/,          :name=>"MINUS"              },
            {:regex=>/\*/,          :name=>"MULTIPLICATION SIGN"},
            {:regex=>/\//,          :name=>"SLASH"              },
            {:regex=>/[a-zA-Z]\w*/, :name=>"IDENTIFIER"         },
            {:regex=>/\d{1,}/,      :name=>"NUMBER"             },
            {:regex=>/\#/,          :name=>"EMPTY CANVAS"       },
            {:regex=>/\'/,          :name=>"TRANSPOSE"          },
            {:regex=>/\$/,          :name=>"ROTATION"           },
            {:regex=>/\.\./,        :name=>"COMPREHENSION"      },
            {:regex=>/./,           :name=>"404"                }   
        ]

        #Arreglo de expresiones para comentarios y posibles malformaciones
        @COMMENTS = [
            {:regex=>/\{\-(.*\-\}){2,}/m , :type=>"MULTICLOSE" },
            {:regex=>/\{\-(.*\-\}){1}/m  , :type=>"GOODCOMMENT"},
            {:regex=>/\{\-/             , :type=>"BADOPEN"    },
            {:regex=>/\-\}/             , :type=>"BADCLOSE"   },
        ]
        
        @myFile   = myFile
        @myTokens = []
        @myErrors = []
        @line     = 1
        @column   = 1

    end

    def findAll

        while !@myFile.empty? do
            
            #Extraccion de cadenas de caracteres ignorables
            self.ignoreWhiteSpace
            self.extractComments 
            self.ignoreWhiteSpace
            
            # Para cada elemento en la lista de tokens
            @MAYBETOKEN.each do |mb|

                # Compara lo leido con el posible token
                @myFile =~ /\A#{mb[:regex]}/
                
                # Si coincide
                if $&
                    # Extrae la palabra
                    word = @myFile[0,($&.length)]
                    
                    # Verifica si el elemento encotrado era valido
                    if mb[:name].eql?"404"
                        # Crea error en caso de haber llegado al final
                        errorFound = Error.new(word,@line,@column,"UNEXPECTED")
                        @myErrors << errorFound
                    elsif mb[:name].eql?"NUMBER"
                        if self.is32bits?word
                            newtoken = Token.new(mb[:name],word,@line,@column)
                            @myTokens << newtoken
                        else
                            errorFound = Error.new(word,@line,@column,"OVERFLOW")
                            @myErrors << errorFound
                        end
                    else
                        # Crea un token en caso valido
                        newtoken = Token.new(mb[:name],word,@line,@column)
                        @myTokens << newtoken
                    end
                    
                    self.skip(word)

                    break
                end

            end

            break if @myFile.empty?

        end 
    end

    #Indica si un numero es representable en 32bits con signo
    def is32bits?(word)
        return word.to_i <= 2**31
    end

    # Metodo para eliminar comentarios y encontrar errores en su formacion
    def extractComments

        @COMMENTS.each do |c|
            @myFile =~ /\A#{c[:regex]}/
            word = $&

            #Si se encuentra un match
            if word

                #Se crea error en caso de no ser comentario bien formado
                unless c[:type].eql?"GOODCOMMENT"
                    errorFound = Error.new("",@line,@column,c[:type])
                    @myErrors << errorFound
                end

                #Se ignora toda la cadena encontrada
                self.skip(word)
                break
            end
            
        end
    end

    #Metodo que elimina caracteres en blanco
    def ignoreWhiteSpace
        #Extraccion de espacios, saltos de linea y tabuladores
        @myFile =~ /\A(\ |\s)*/ 
        self.skip($&)
    end

    # Metodo para correr el cursor 
    def skip(word)

        # Quita la palabra leida
        unless word.nil?
            word.each_char do |c|  
                if c.eql?"\n"
                    @line +=1 
                end
                @column +=1
            end
            
            @myFile = @myFile[word.length..@myFile.length]
        end
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
