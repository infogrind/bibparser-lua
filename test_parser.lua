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
end

macros, entries = parser(scanner(charreader()))

print_table(macros)
print_entries(entries)
