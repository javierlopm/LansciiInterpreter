class Calcparser::Parser
rule
  target: exp 

  exp: exp '+' exp { puts "estoy en + #{val}" }
     | exp '*' exp { puts "estoy en * #{val}" }
     | '(' exp ')' { puts "estoy en () #{val}" }
     | NUMBER      { puts "estoy en NUMBER #{val}"}
end

---- inner ----
    def parser(tokens)
        @tokens = tokens
        do_parse
    end

    def next_token
        @tokens.shift
    end