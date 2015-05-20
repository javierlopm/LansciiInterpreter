#Nodo de arbol general
class Node

    def initialize(content,child=nil)
        @content = content
        if child.nil?
            @children = []
        else
            @children << child
        end
    end

    def insertChild(child)
        @children << child
    end

end

#Clase para un arbol general
class Tree
    def initialize(content)
        root = Node::new(content)
    end
end