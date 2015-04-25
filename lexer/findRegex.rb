class FindRegex

    @regexDic

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
        "CANVAS",
        "CANVAS",
        "CANVAS",
        "CANVAS",
        "TRANSPOSE",
        "ROTATION",
        "HORIZONTALCAT",    #???????
        "VERTICALCAT",      #???????
        "LCOMMENT",
        "RCOMMENT",
        "COMPREHENSION"     #??????
    ]

    def initialize(args)
        
    end

    def findAll(program)

    end
    
    
end