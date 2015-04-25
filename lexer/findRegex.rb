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
        /[/,
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
