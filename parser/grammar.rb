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

#Precedencias
prechigh
    nonassoc NOT
    left AND
    left OR 

    nonassoc MINUS
    left MULTIPLY SLASH PERCENT
    left PLUS MINUS

    nonassoc LESS LESSTHAN MORE MORETHAN EQUALS NOTEQUALS

    nonassoc TRANSPOSE 
    nonassoc ROTATION
    left VERTICALCAT HORIZONTALCAT

preclow

rule
  target: program {puts "#{val}"}

  program: "{" declare "|" instruction "}" #No sure about this, va programa y coloque instruction
         | "{"instruction"}"
  
  declare: PERCENT         identifierlist
         | EXCLAMATIONMARK identifierlist
         | AT              identifierlist
         | declare declare
         | declare

  identifierlist: identifierlist IDENTIFIER
                | identifier
  
  instruction: assigment        #Retorno de objeto encontrado en cada caso
             | sequence
             | input
             | output
             | conditional
             | notDetIteration
             | detIteration

  assigment: IDENTIFIER "=" exp {result = Asign::new($2,$4)}

  sequence: instruction ";" instruction {result = Secuence::new($2,$4,$6)}

  input: READ IDENTIFIER   {result = Read::new($1)}

  output: WRITE IDENTIFIER {result = Write::new($1)}

  conditional: "(" exp "?" instruction ")"          {result = Conditional::new($2,$4)}
             | "(" exp "?" instruction ":" instruction ")" {result = Conditional2::new($2,$4,$6)}

  notDetIteration: "[" exp ".." exp "|" instruction "]" {result = DIteration::new($2,$4,$6)}

  detIteration: "[" identifier ":" exp ".." exp  "|" instruction "]" {result = DIteration2::new($2,$4,$6,$8)}

  exp: IDENTIFIER
       #Bool
     | exp AND exp  {result = ExprAnd::new($1,$3)}
     | exp OR  exp  {result = ExprOr::new($1,$3)}
     | exp NOT      {result = ExprNot::new($1)}
     | TRUE         {result = ExprTrue::new()}
     | FALSE        {result = ExprFalse::new()}
       #Comparadores 
     | exp LESSTHAN  exp  {result = ExprLessEql::new($1,$3)}
     | exp MORETHAN  exp  {result = ExprMoreEql::new($1,$3)}
     | exp LESS      exp  {result = ExprLess::new($1,$3)}   
     | exp MORE      exp  {result = ExprMore::new($1,$3)}    
     | exp EQUALS    exp  {result = ExprEql::new($1,$3)} 
     | exp NOTEQUALS exp  {result = ExprDiff::new($1,$3)}
       #Canvas
     | exp HORIZONTALCAT exp {result = ExprHorConcat::new($1,$3)}
     | exp VERTICALCAT exp   {result = ExprVerConcat::new($1,$3)}
     | exp TRANSPOSE         {result = ExprTranspose::new($1)}
     | ROTATION exp          #{result = Expr::new($2)}
     | EMPTYCANVAS           {result = ExprEmptyCanvasE::new()}
     | CANVAS                {result = ExprCanvas::new($1)}
       #Artimeticos 
     | exp PLUS exp           {result = ExprSum::new($1,$3)}
     | exp MINUS exp          {result = ExprSubs::new($1,$3)}
     | exp MULTIPLY exp       {result = ExprMult::new($1,$3)}
     | exp SLASH exp          {result = ExprDiv::new($1,$3)}
     | exp PERCENT exp        {result = ExprMod::new($1,$3)}
     | MINUS exp              {result = ExprUnMinus::new($1.to_i)}  
     | "(" exp ")"             
     | NUMBER        {result = ExprNumber::new(val[0].to_i)}
end

---- header ----
require_relative "TokenClasses"

---- inner ----
    def parser(tokens)
        @tokens = tokens
        do_parse
    end

    def next_token
        @tokens.shift
    end