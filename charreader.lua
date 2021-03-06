require("sendrec")

function charreader(filename)
    if filename ~= nil then
        io.input(filename)
    end

    return coroutine.create(function()
        while true do
            local c = io.read(1)
            send(c)
            -- If the end of the file has been reached, exit the loop.
            if c == nil then break end
        end
    end)

end
