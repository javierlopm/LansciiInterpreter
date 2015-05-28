#Nodo de arbol general
class Node

  def initialize(content,child=nil)
    @content = content
    if child.nil?
      @children = []
    else
      @children << child
    end

    @level = 0
  end

  def setLevel(level)
    @level = level
  end

  def insertChild(child)
    child.setLevel(@level+1) #Creo que estos levels se deberian calcular solo al momento de imprimir, no tiene sentido durante la construccion
    @children << child
  end



  def printNode(isFirst=true)

    # if isFirst
      
    # end

    for i in 0..@level-1 do
        print "|   "
    end 

    puts "#{@content}"
    
    unless @children.nil?
      @children.each do |n|
        n.printNode()
      end
    end
  end

end

#Clase para un arbol general
class Tree
  def initialize(content)
    root = Node::new(content)
  end
end

as  = Node::new("ASSIGN")
var = Node::new("VARIABLE:")
id  = Node::new("IDENTIFIER: bar")
exp = Node::new("EXPRESION")
num = Node::new("NUMBER: 3")
# 
as.insertChild(var)
as.insertChild(exp)
var.insertChild(id)
exp.insertChild(num)

as.printNode()