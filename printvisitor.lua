require("syntax")

tabstop = 3

function print_visitor()
    visitor = {}
    visitor.indent = -tabstop
   
    visitor.visit = function(self, tree)
        self:inc_indent()
        tree:visit(self)
        self:dec_indent()
    end

    visitor.case_bibtex = function(self, bibtex)
        self:pindent("+- bibtex tree")
        for i, v in ipairs(bibtex.items) do
            self:visit(v)
        end
    end

    visitor.case_item = function(self, item)
        self:pindent("+- item")
        self:visit(item.type)
        self:visit(item.content)
    end

    visitor.case_macro = function(self, macro)
        self:pindent("+- macro")
        self:visit(macro.name)
        self:visit(macro.value)
    end

    visitor.case_entry = function(self, entry)
       self:pindent("+- entry")
       self:visit(entry.name)
       for i, v in ipairs(entry.attributes) do
           self:visit(v)
       end
    end

    visitor.case_attribute = function(self, attribute) 
        self:pindent("+- attribute")
        self:visit(attribute.name)
        self:visit(attribute.value)
    end

    visitor.case_value = function(self, value)
        self:pindent("+- value")
        for i,v in ipairs(value.items) do
            self:visit(v)
        end
    end

    visitor.case_string = function(self, string)
        self:pindent("+- string(" .. string.value .. ")")
    end

    visitor.case_ident = function(self, ident)
        self:pindent("+- ident(" .. ident.value .. ")")
    end

    visitor.inc_indent = function(self)
        self.indent = self.indent + tabstop
    end

    visitor.dec_indent = function(self)
        self.indent = self.indent - tabstop
    end

    visitor.pindent = function(self, s)
        for i = 1,self.indent do
            io.write(' ')
        end
        io.write(s, "\n")
    end

    return visitor
end
