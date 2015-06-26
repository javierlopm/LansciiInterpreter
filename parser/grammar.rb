class Calcparser::Parser

convert
  #ParserTokens   LexerTokens
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
  LESSEQL         '"LESSEQL"'
  MOREEQL         '"MOREEQL"'
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
    left SEMICOLON
    nonassoc NOT 
    left     AND
    left     OR 

    nonassoc MINUS
    left     MULTIPLY SLASH PERCENT
    left     PLUS MINUS

    nonassoc LESS LESSEQL MORE MOREEQL EQUALS NOTEQUALS

    nonassoc TRANSPOSE 
    nonassoc ROTATION
    left     VERTICALCAT HORIZONTALCAT

    left DECLARATERULE
    left SEQUENCERULE
preclow

rule
  target: program {result = val[0]}

  program: LCURLY declare PIPE instruction RCURLY  {
            result = Program::new(val[3],val[1])
           }
         | LCURLY instruction RCURLY   {
          result = Program::new(val[1])
         }
  
  #Declaraciones sin construccion, siguiente entrega
  declare: PERCENT         identifierlist {
              st = SymbolTable::new()
              st.insert_symbol_list(val[1],val[0])
              result = st 
           }
         | EXCLAMATIONMARK identifierlist {
              st = SymbolTable::new()
              st.insert_symbol_list(val[1],val[0])
              result = st 
           }
         | AT              identifierlist {
              st = SymbolTable::new()
              st.insert_symbol_list(val[1],val[0])
              result = st 
           }
         | declare PERCENT         identifierlist {
              val[0].insert_symbol_list(val[2],val[1])
              result = val[0] 
           }
         | declare EXCLAMATIONMARK identifierlist {
              val[0].insert_symbol_list(val[2],val[1])
              result = val[0] 
           }
         | declare AT              identifierlist {
              val[0].insert_symbol_list(val[2],val[1])
              result = val[0] 
           }


  identifierlist: identifierlist IDENTIFIER  {result = val[0] << val[1]}
                | IDENTIFIER                 {result = [val[0]]        }

  instruction: assigment        
             | sequence
             | input
             | output
             | conditional
             | notDetIteration
             | detIteration
             | varIncorporationRange
             | noVarIncoporationRange

  assigment: IDENTIFIER EQUALS exp  = ASSIGNMENTRULE {
                identifier = ExprId::new(val[0])
                result = Asign::new(identifier,val[2])
            }

  sequence: instruction SEMICOLON instruction = SEQUENCERULE { result = Secuence::new(val[0],val[2])}
            

  input: READ IDENTIFIER   {
            identifier = ExprId::new(val[1])
            result     = Read::new(identifier)
        }

  # output: WRITE IDENTIFIER {
            # identifier = ExprId::new(val[1])
            # result = Write::new(identifier)
        # }  
  output: WRITE exp {
            #identifier = ExprId::new(val[1])
            result = Write::new(val[1])
        }

  conditional:  LPARENTHESIS exp QUESTIONMARK instruction RPARENTHESIS {
                    result = Conditional::new(val[1],val[3])
             }
             | LPARENTHESIS exp QUESTIONMARK instruction COLON instruction RPARENTHESIS {result = Conditional2::new(val[1],val[3],val[5])}

  notDetIteration: LSQUARE exp PIPE instruction RSQUARE {
                        result = IIteration::new(val[1],val[3])
                   }

  detIteration: LSQUARE exp COMPREHENSION exp PIPE instruction RSQUARE {
                    result = DIteration::new(val[1],val[3],val[5])
                }
              | LSQUARE IDENTIFIER COLON exp COMPREHENSION exp  PIPE instruction RSQUARE {
                    #Creacion de tabla
                    #identifier = ExprId::new(val[1])
                    st = SymbolTable::new()
                    st.insert_symbol(val[1],0,false)     #entero implicito
                    result = DIteration2::new(val[1].get_name,st,val[3],val[5],val[7])
                }

  varIncorporationRange:  LCURLY declare PIPE instruction RCURLY  {
                            result = VarBlock::new(val[1],val[3])
                          } 
  
  noVarIncoporationRange: LCURLY instruction RCURLY {
                            result = Block::new(val[1])
                          }

  exp: IDENTIFIER   {result = ExprId::new(val[0])}
       #Bool
     | exp AND exp  {result = ExprAnd::new(val[0],val[2])}
     | exp OR  exp  {result = ExprOr::new(val[0],val[2])}
     | exp NOT      {result = ExprNot::new(val[0])}
     | TRUE         {result = ExprTrue::new()}
     | FALSE        {result = ExprFalse::new()}
       #Comparadores 
     | exp LESSEQL   exp  {result = ExprLessEql::new(val[0],val[2])}
     | exp MOREEQL   exp  {result = ExprMoreEql::new(val[0],val[2])}
     | exp LESS      exp  {result = ExprLess::new(val[0],val[2])}   
     | exp MORE      exp  {result = ExprMore::new(val[0],val[2])}    
     | exp EQUALS    exp  {result = ExprEql::new(val[0],val[2])} 
     | exp NOTEQUALS exp  {result = ExprDiff::new(val[0],val[2])}
       #Canvas
     | exp HORIZONTALCAT exp {result = ExprHorConcat::new(val[0],val[2])}
     | exp VERTICALCAT   exp {result = ExprVerConcat::new(val[0],val[2])}
     | exp TRANSPOSE         {result = ExprTranspose::new(val[0])}
     | ROTATION  exp         {result = Expr::new(val[2])}
     | EMPTYCANVAS           {result = ExprEmptyCanvas::new}
     | CANVAS                {result = ExprCanvas::new(val[0])}
       #Artimeticos 
     | exp PLUS     exp   {result = ExprSum::new(val[0],val[2])}
     | exp MINUS    exp   {result = ExprSubs::new(val[0],val[2])}
     | exp MULTIPLY exp   {result = ExprMult::new(val[0],val[2])}
     | exp SLASH    exp   {result = ExprDiv::new(val[0],val[2])}
     | exp PERCENT  exp   {result = ExprMod::new(val[0],val[2])}
     | MINUS exp          {result = ExprUnMinus::new(val[1])}  
     | LPARENTHESIS exp RPARENTHESIS        {result = val[1]}           
     | NUMBER             {result = ExprNumber::new(val[0].to_i)}
end

---- header ----
require_relative "TokenClasses"
require_relative "../dataStructures/symbolTable"

---- inner ----
    def parser(tokens)
        @tokens = tokens
        do_parse
    end

    def next_token
        @tokens.shift
    end