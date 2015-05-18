#!/usr/bin/env ruby

require_relative 'racc.rb'

ast = Calcparser::Parser.new.parser(
    [['(','('],
     [:NUMBER,'2'],
     ['+','+'] , 
     [:NUMBER,'3'],
     [')',')']
    ])
