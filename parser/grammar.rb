class Calcparser::Parser

convert
  #ParserTokens   LexertTokens
  LCURLY          '"LCURLY"'
  RCURLY          '"RCURLY"'
  PIPE            '"PIPE"'
  PERCENT         '"PERCENT"'
  EXCLAMATIONMARK '"EXCLAMATIONMARK"'
  AT              '"AT"'
  EQUALS          '"EQUALS"'
  SEMICOLON       '"SEMICOLON"'
  READ            '"READ"'
  WRITE           '"WRITE"'
  QUESTIONMARK    '"QUESTIONMARK"'
  COLON           '"COLON"'
  LSQUARE         '"LSQUARE"'
  RSQUARE         '"RSQUARE"'
  LPARENTHESIS    '"LPARENTHESIS"'
  RPARENTHESIS    '"RPARENTHESIS"'
  TRUE            '"TRUE"'
  FALSE           '"FALSE"'
  AND             '"AND"'
  OR              '"OR"'
  CANVAS          '"CANVAS"'
  NOT             '"NOT"'
  LESSTHAN        '"LESSTHAN"'
  MORETHAN        '"MORETHAN"'
  NOTEQUALS       '"NOTEQUALS"'
  LESS            '"LESS"'
  MORE            '"MORE"'
  PLUS            '"PLUS"'
  MINUS           '"MINUS"'
  MULTIPLY        '"MULTIPLICATION SIGN"'
  SLASH           '"SLASH"'
  IDENTIFIER      '"IDENTIFIER"'
  NUMBER          '"NUMBER"'
  EMPTYCANVAS     '"EMPTY CANVAS"'
  TRANSPOSE       '"TRANSPOSE"'
  ROTATION        '"ROTATION"'
  HORIZONTALCAT   '"HORIZONTAL CONCAT"'
  VERTICALCAT     '"VERTICAL CONCAT"'
  COMPREHENSION   '"COMPREHENSION"'
end

rule
  target: program {puts "#{val}"}

  program: "{" declare "|" program "}"
         | "{"instruction"}"
  
  declare: PERCENT         identifierlist
         | EXCLAMATIONMARK identifierlist
         | AT              identifierlist
         | declare declare
         | declare

  identifierlist: identifierlist IDENTIFIER
                | identifier
  
  instruction: assigment
             | sequence
             | input
             | output
             | conditional
             | notDetIteration
             | detIteration

  assigment: IDENTIFIER "=" exp

  sequence: instruction ";" instruction

  input: READ IDENTIFIER

  output: WRITE IDENTIFIER

  conditional: "(" exp "?" instruction ")"
             | "(" exp "?" instruction ":" instruction ")"

  notDetIteration: "[" exp ".." exp "|" instruction "]"

  detIteration: "[" identifier ":" exp ".." exp  "|" instruction "]"

  exp: IDENTIFIER
       #Bool
     | exp AND exp  
     | exp OR  exp  
     | exp NOT      
     | TRUE         
     | FALSE
       #Comparadores 
     | exp LESSTHAN exp  
     | exp MORETHAN exp  
     | exp LESS  exp     
     | exp MORE exp      
     | exp EQUALS exp   
     | exp NOTEQUALS exp 
       #Canvas
     | exp HORIZONTALCAT exp 
     | exp VERTICALCAT exp   
     | exp TRANSPOSE         
     | ROTATION exp         
     | EMPTYCANVAS           
     | CANVAS
       #Artimeticos 
     | exp PLUS exp 
     | exp MINUS exp 
     | exp MULTIPLY exp 
     | exp SLASH exp 
     | exp PERCENT exp
     | exp exp                
     | NUMBER 
end

---- header ----
require_relative "tokenClasses"

---- inner ----
    def parser(tokens)
        @tokens = tokens
        do_parse
    end

    def next_token
        @tokens.shift
    end