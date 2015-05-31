task :compile_grammar do
    `racc ./parser/grammar.rb -oparser/racc.rb`
end

task :debug do
    `racc ./parser/grammar.rb -v -g -oparser/racc.rb`
    sh 'less parser/racc.output'
    sh 'ruby lanscii parsere/example/example5.lc'
end

task :run => [:compile_grammar] do
    #sh 'ruby lanscii'
    sh 'ruby lanscii parser/example/example5.lc'
end
