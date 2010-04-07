syntax = {}
syntax.make_bibtex = function(items)
    local bibtex = {}
    bibtex.items = items
    bibtex.visit = function(self, visitor) visitor:case_bibtex(self) end
    return bibtex
end

syntax.make_item = function(type, content)
    local item = {}
    item.type = type
    item.content = content
    item.visit = function(self, visitor) visitor:case_item(self) end
    return item
end

syntax.make_macro = function(name, value)
    local macro = {}
    macro.name = name
    macro.value = value
    macro.visit = function(self, visitor) visitor:case_macro(self) end
    return macro
end

syntax.make_entry = function(name, attributes)
    local entry = {}
    entry.name = name
    entry.attributes = attributes
    entry.visit = function(self, visitor) visitor:case_entry(self) end
    return entry
end

syntax.make_attribute = function(name, value)
    local attribute = {}
    attribute.name = name
    attribute.value = value
    attribute.visit = function(self, visitor)
        visitor:case_attribute(self)
    end
    return attribute
end

syntax.make_value = function(items)
    local value = {}
    value.items = items
    value.visit = function(self, visitor) visitor:case_value(self) end
    return value
end

syntax.make_string = function(value)
    local string = {}
    string.value = value
    string.visit = function(self, visitor) visitor:case_string(self) end
    return string
end

syntax.make_ident = function(value)
    local ident = {}
    ident.value = value
    ident.visit = function(self, visitor) visitor:case_ident(self) end
    return ident
end

