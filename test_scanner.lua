require("tokens")
require("scanner")
require("charreader")

function consumer(prod)
    while true do
        t, s = receive(prod)
        if t == Tokens.EOF then
            print("End of file reached.")
            break;
        elseif t == Tokens.AT then
            print("AT")
        elseif t == Tokens.LBRACE then
            print("LBRACE")
        elseif t == Tokens.RBRACE then
            print("RBRACE")
        elseif t == Tokens.EQ then
            print("EQ")
        elseif t == Tokens.COMMA then
            print("COMMA")
        elseif t == Tokens.QUOTE then
            print("QUOTE")
        elseif t == Tokens.HASH then
            print("HASH")
        elseif t == Tokens.STRING then
            print("STRING(" .. s .. ")")
        elseif t == Tokens.IDENT then
            print("IDENT(" .. s .. ")")
        else
            error("Scanner returned invalid token identifier: " .. t)
        end
    end
end

consumer(scanner(charreader()))
