class Calcparser::Parser
rule
  target: exp 

  exp: exp '+' exp { puts "estoy en + #{val}" }
     | exp '*' exp { puts "estoy en * #{val}" }
     | '(' exp ')' { puts "estoy en () #{val}" }
     | NUMBER      { puts "estoy en NUMBER #{val}"}
     | IDENTIFIER      { puts "estoy en NUMBER #{val}"}
end