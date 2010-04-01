require("tokens")
require("scanner")
require("charreader")

function consumer(prod)
    while true do
        t, s = receive(prod)
        print(token_to_string(t, s))
        if t == Tokens.EOF then break end
    end
end

consumer(scanner(charreader()))
