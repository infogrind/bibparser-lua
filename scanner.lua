require("sendrec")
require("tokens")
require("debugmsg")

-- For single-letter tokens and EOF, this function returns a single value.
-- For identifiers and strings, the second returned value is a string with the
-- value of the ident resp. string.
function scanner(reader)

    function iswhitespace(c)
        return c == ' ' or c == '\n' or c == '\t'
    end

    function isidentchar(c)
        return
        (c >= 'A' and c <= 'Z') or
        (c >= 'a' and c <= 'z') or
        (c >= '0' and c <= '9') or
        c == '_' or
        c == '-' or
        c == ':'
    end

    return coroutine.create(function ()
        local bracelevel = 0    -- indicates if we are inside nested {}
        local c                 -- character read
        local afterequal = false    -- have we just read an equal sign?

        local stringbuffer = {}

        function skipwhitespace()
            if iswhitespace(c) then
                c = receive(reader)
                return skipwhitespace()
            else
                return dispatch()
            end
        end

        function skipcomment() -- swallow everything until newline character
                               -- (which will be eaten by skipwhitespace)
            c = receive(reader)
            if c ~= '\n' then
                return skipcomment()
            else
                return dispatch()
            end
        end

        function dispatch()
            if iswhitespace(c) then
                return skipwhitespace()
            elseif c == '%' then
                return skipcomment()
            else
                return scantoken()
            end
        end

        function nextchar()
            c = receive(reader)
            return dispatch()
        end

        function scantoken()
            if c == nil then
                send(Tokens.EOF)
                return nextchar()
            elseif c == '@' then
                send(Tokens.AT)
                return nextchar()
            elseif c == '{' then
                if afterequal then
                    return scanbracestring()
                else
                    send(Tokens.LBRACE)
                    return nextchar()
                end
            elseif c == '}' then
                afterequal = false
                send(Tokens.RBRACE)
                return nextchar()
            elseif c == '=' then
                afterequal = true
                send(Tokens.EQ)
                return nextchar()
            elseif c == ',' then
                afterequal = false
                send(Tokens.COMMA)
                return nextchar()
            elseif c == '"' then
                -- We swallow the first quote.
                c = receive(reader)
                return scanquotestring()
            elseif c == '#' then
                send(Tokens.HASH)
                return nextchar()
            elseif isidentchar(c) then
                return scanident()
            else
                error('Invalid token: ' .. c)
            end
        end

        function scanbracestring()
            if c == '}' and bracelevel == 1 then
                -- end of string
                bracelevel = 0
                send(Tokens.STRING, table.concat(stringbuffer))
                stringbuffer = {}
                return nextchar()
            else
                if c == '{' then
                    if bracelevel > 0 then
                        table.insert(stringbuffer, c)
                    end
                    bracelevel = bracelevel + 1
                elseif c == '}' then
                    if bracelevel > 1 then
                        table.insert(stringbuffer, c)
                        bracelevel = bracelevel - 1
                    end
                else
                    -- For everything else, just insert the character.
                    table.insert(stringbuffer, c)
                end

                c = receive(reader)
                return scanbracestring()
            end
        end

--        function scanbracestring()
--            if c == '{' then
--                if bracelevel == 0 then
--                    -- this brace starts the string, we can skip it.
--                    bracelevel = 1
--                else
--                    -- this brace is part of the string.
--                    table.insert(stringbuffer, c)
--                    bracelevel = bracelevel + 1
--                end
--
--                c = receive(reader)
--                scanbracestring()
--
--            elseif c == '}' then
--                if bracelevel == 1 then
--                    -- this brace closes the string, we skip it and stop.
--                    bracelevel = 0
--                    send(Tokens.STRING, table.concat(stringbuffer))
--                    stringbuffer = {}
--                    c = receive(reader)
--                    dispatch()
--                else
--                    table.insert(stringbuffer, c)
--                    bracelevel = bracelevel - 1
--                    c = receive(reader)
--                    scanbracestring()
--                end
--            else
--                -- regular character, add to string
--                table.insert(stringbuffer,c)
--                c = receive(reader)
--                scanbracestring()
--            end
--
--        end

        function scanquotestring()
            if c == '"' then
                -- end of string reached
                send(Tokens.STRING, table.concat(stringbuffer))
                stringbuffer = {}
                c = receive(reader)
                return dispatch()
            else
                table.insert(stringbuffer, c)
                c = receive(reader)
                return scanquotestring()
            end
        end

        function scanident()
            if isidentchar(c) then
                table.insert(stringbuffer, c)
                c = receive(reader)
                return scanident()
            else
                -- identifier ended, send token and return control to
                -- dispatcher. 
                send(Tokens.IDENT, table.concat(stringbuffer))
                stringbuffer = {}
                return dispatch()
            end
        end

        -- Initial character read and dispatching.
        c = receive(reader)
        return dispatch()
    end)
end
