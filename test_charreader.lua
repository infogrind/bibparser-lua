require("sendrec")
require("charreader")

function consumer(prod)
    while true do
        local val, class = receive(prod)
        if val == nil then
            io.write("End-of-file\n")
            break
        end
        io.write("Character: ", val)
        if (class ~= nil) then io.write(" (special)") end
        io.write("\n")
    end
end

consumer(charreader())
