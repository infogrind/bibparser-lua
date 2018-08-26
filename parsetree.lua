require("sendrec")
require("scanner")
require("syntax")

function print_table(t)
    for k, v in pairs(t) do
        print(k, v)
    end
end

function parser(scanner)
    local t, s              -- currently read token and string (if any)

    function next_token()
        t, s = receive(scanner)
        debugmsg("Found token: " .. token_to_string(t, s))
    end

    -- This function raises an error if the current token is not tok, and
    -- displays a message using the given string.
    -- Otherwise, it moves on to the next token. 
    -- If the current token has a string attribute, it returns this. 
    function verify_token(tok)
        local val = s
        if t ~= tok then
            error("Expected: " .. token_to_string(tok) .. ", found " ..
            token_to_string(t, s))
        end
        next_token()
        return val
    end

    function parse_bibtex()
        debugmsg("Parsing bibtex file")
        local items = {}
        while true do
            if t == Tokens.EOF then
                break -- done parsing
            else
                -- there must be a bibtex item
                local item = parse_item()
                table.insert(items, item)
            end
        end
        print("There are " .. #items .. " items in total")
        return syntax.make_bibtex(items)
    end

    function parse_item()
        debugmsg("Parsing item")

        -- First part: @
        verify_token(Tokens.AT)

        -- Second part: identifier
        local ident = parse_ident()

        if ident.value == "string" then
            return syntax.make_item(ident, parse_macro())
        else
            return syntax.make_item(ident, parse_entry())
        end
    end

    function parse_macro()
        debugmsg("Parsing macro")
        local name, value
        verify_token(Tokens.LBRACE)
        name = parse_ident()
        verify_token(Tokens.EQ)
        value = parse_value()
        verify_token(Tokens.RBRACE)

        return syntax.make_macro(name, value)
    end

    function parse_value()
        debugmsg("Parsing value")
        local items = {}
        if t ~= Tokens.IDENT and t ~= Tokens.STRING then
            error("Expected: identifier or string")
        end
        repeat
            if t == Tokens.IDENT then
                table.insert(items, syntax.make_ident(s))
            elseif t == Tokens.STRING then
                table.insert(items, syntax.make_string(s))
            end

            -- If next token is a hash, we continue. otherwise we stop
            next_token()
            if t == Tokens.HASH then
                next_token()
            else
                -- This was the last part of the value.
                debugmsg("end of value")
                return syntax.make_value(items)
            end
        until false
    end

    function parse_entry()
        debugmsg("Parsing entry")
        local name

        verify_token(Tokens.LBRACE)
        name = parse_ident()
        return syntax.make_entry(name, parse_attributes())
    end

    function parse_attributes()
        debugmsg("Parsing attributes")
        local attr = {}

        while t ~= Tokens.RBRACE do
            verify_token(Tokens.COMMA, ', or }')
            table.insert(attr, parse_attribute())
        end

        next_token()
        return attr
    end

    function parse_attribute()
        debugmsg("Parsing attribute")
        local name = parse_ident() 
        verify_token(Tokens.EQ)
        return syntax.make_attribute(name, parse_value())
    end

    function parse_ident()
        if t ~= Tokens.IDENT then
            error("Expected identifier, found " .. token_to_string(t, s))
        end
        local ident = syntax.make_ident(s)
        next_token()
        return ident
    end

    function parse_string()
        if t ~= Tokens.STRING then
            error("Expected string, found " .. token_to_string(t, s))
        end
        local string = syntax.make_string(s)
        next_token()
        return string
    end

    next_token()
    return parse_bibtex()
end
