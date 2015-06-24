task :compile_grammar do
    `racc ./parser/grammar.rb -oparser/racc.rb`
end

task :debug do
    `racc ./parser/grammar.rb -v -g -oparser/racc.rb`
    sh 'less parser/racc.output'
    sh 'ruby lanscii parsere/example/example5.lc'
end

task :suite => [:compile_grammar] do

    sh "echo 'SUITE de ejemplo' > salida.txt"

    (1...10).each do |ej|
        a = "parser/example/example#{ej}.lc"
        puts "CORRIENDO #{a}"
        sh " echo 'CORRIENDO #{a}' >> salida.txt"

        sh "cat #{a} >> salida.txt"
        sh "./lanscii #{a} >> salida.txt"
        sh "echo '\n\n\n' >> salida.txt"
    end
    
end

task :run => [:compile_grammar] do
    sh "./lanscii parser/example/example1.lc"
end

task :runBadGrammar => [:compile_grammar] do
    sh "./lanscii parser/example/example8.lc"
end
