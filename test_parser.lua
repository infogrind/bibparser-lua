require("charreader")
require("scanner")
require("parser")

function print_table(t)
    for k, v in pairs(t) do
        print(k, v)
    end
end

function print_entries(e)
    function print_attributes(a)
        for k, v in pairs(a) do
            io.write(k, " = \"", v, "\"\n")
        end
    end

    for k, v in pairs(e) do
        io.write("@", v.type, "{\n")
        print_attributes(v)
        io.write("}\n")
    end

    print()
end

function attribute_list(e, a)
    local j = {}
    for k, v in pairs(e) do
        if v[a] ~= nil then
            j[v[a]] = true
        end
    end

    local t = set2array(j)
    table.sort(t)
    return t
end

function set2array(s)
    a = {}
    for k in pairs(s) do
        table.insert(a, k)
    end
    return a
end

function journals(e)
    return attribute_list(e, "Journal")
end

function books(e)
    return attribute_list(e, "Booktitle")
end

function print_attribute(e, a)
    print("Attribute " .. a .. ":")
    print_table(attribute_list(e, a))
    print()
end

macros, entries = parser(scanner(charreader()))

--print("======== MACROS =========")
--print_table(macros)
--print()
--print("======== ENTRIES =========")
--print_entries(entries)
--print()
print_attribute(entries, "Journal")
print_attribute(entries, "Booktitle")
