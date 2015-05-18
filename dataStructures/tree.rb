#Nodo de arbol general
class Node
    def initialize(content,childs=nil)
        @content = content
        @childs  = childs   #Lista de hijos
    end

end

#Clase para un arbol general
class Tree
    def initialize(content)
        root = Node::new(content)
    end
end