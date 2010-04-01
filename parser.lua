require("sendrec")
require("scanner")

function parser(scanner)
    local macros = {}
    local entries = {}
    local t, s              -- currently read token and string (if any)

    function next_token()
        t, s = receive(scanner)
        debugmsg("Found token: " .. token_to_string(t, s))
    end

    -- This function raises an error if the current token is not tok, and
    -- displays a message using the given string.
    -- Otherwise, it moves on to the next token. 
    -- If the current token has a string attribute, it returns this. 
    function verify_token(tok, str)
        local val = s
        if t ~= tok then
            error("Expected: " .. str .. ", found " .. token_to_string(t, s))
        end
        next_token()
        return val
    end

    function parse_bibtex()
        debugmsg("Parsing bibtex file")
        while true do
            if t == Tokens.EOF then
                break -- done parsing
            else
                -- there must be a bibtex item
                parse_item()
            end
        end
    end

    function parse_item()
        debugmsg("Parsing item")
        local entry = {}
        local entrytype

        -- First part: @
        if t ~= Tokens.AT then error("Expected: @") end
        next_token()

        -- Second part: identifier
        if t ~= Tokens.IDENT then error("Expected: identifier") end

        if s == "string" then
            next_token()
            name, value = parse_macro()
            macros[name] = value
        else
            entrytype = s
            next_token()
            name, attr = parse_entry()
            assert(attr ~= nil)
            attr.type = entrytype
            if entries[name] ~= nil then
                io.write("Warning: duplicate entry '", name, "'\n")
            end
            entries[name] = attr
        end
    end

    function parse_macro()
        debugmsg("Parsing macro")
        local name, value
        verify_token(Tokens.LBRACE, "{")
        name = verify_token(Tokens.IDENT, 'identifier')
        verify_token(Tokens.EQ, "=")
        value = parse_value()
        verify_token(Tokens.RBRACE, '}')

        return name, value
    end

    function parse_value()
        debugmsg("Parsing value")
        buffer = {}
        if t ~= Tokens.IDENT and t ~= Tokens.STRING then
            error("Expected: identifier or string")
        end
        repeat
            if t == Tokens.IDENT then
                if macros[s] == nil then
                    error("Undefined macro: " .. s)
                else
                    table.insert(buffer, macros[s])
                end
            elseif t == Tokens.STRING then
                assert(t == Tokens.STRING)
                table.insert(buffer, s)
            end

            -- If next token is a hash, we continue. otherwise we stop
            next_token()
            if t == Tokens.HASH then
                next_token()
            else
                -- This was the last part of the value.
                debugmsg("end of value")
                return table.concat(buffer)
            end
        until false
    end

    function parse_entry()
        debugmsg("Parsing entry")
        local name, attr

        verify_token(Tokens.LBRACE, "{")
        name = verify_token(Tokens.IDENT, 'identifier')
        return name, parse_attributes()
    end

    function parse_attributes()
        debugmsg("Parsing attributes")
        attr = {}

        while t ~= Tokens.RBRACE do
            verify_token(Tokens.COMMA, ', or }')
            local name, value = parse_attribute()
            if attr[name] ~= nil then
                io.write("Warning: duplicate attribute '", name, "'\n")
            end
            attr[name] = value
        end

        assert(attr ~= nil)
        next_token()
        return attr
    end

    function parse_attribute()
        debugmsg("Parsing attribute")
        local name = verify_token(Tokens.IDENT, 'identifier')
        local value
        verify_token(Tokens.EQ)
        return name, parse_value()
    end

    next_token()
    parse_bibtex()
    return macros, entries
end
