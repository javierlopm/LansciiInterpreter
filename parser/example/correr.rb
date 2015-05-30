#!/usr/bin/env ruby

require_relative 'racc.rb'

ast = Calcparser::Parser.new.parser(
    [['(','('],
     ["NUMBER",'2'],
     ['+','+'] , 
     ["NUMBER",'3'],
     ['+','+'] , 
     ["NUMBER",'4'],
     ['+','+'] , 
     ["NUMBER",'5'],
    ])

puts "#{ast}"