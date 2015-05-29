class Calcparser::Parser

convert
  NUMBER '"NUMBER"'          # permite usar strings como claves
end

rule
  target: exp {puts "#{val}"}

  exp: exp '+' exp { puts "estoy en + #{val} "; hey = val; return val}
     #| exp '*' exp { puts "estoy en * #{val}"; yippie = val }
     | '(' exp ')' { puts "estoy en () #{val[1]}"; nou = val }
     | NUMBER      { puts "estoy en NUMBER #{val}"; quesesto = val}
end

---- inner ----
    def parser(tokens)
        @tokens = tokens
        do_parse
    end

    def next_token
        @tokens.shift
    end