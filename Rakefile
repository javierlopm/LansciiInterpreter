task :compile_grammar do
    `racc ./parser/grammar.rb -oparser/racc.rb`
end

task :run => [:compile_grammar] do
    sh 'ruby lanscii'
end
