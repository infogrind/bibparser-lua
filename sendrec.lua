require("debugmsg")

-- Functions taken from "Programming in Lua" (first edition), Section 9.2.
function receive(prod)
    status, valarray = coroutine.resume(prod)
    if status == false then
        error("Error in coroutine: " .. valarray)
    end
    return unpack(valarray)
end

function send(...)
    coroutine.yield(arg)
end
