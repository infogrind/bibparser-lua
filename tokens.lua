Tokens = {}

-- Special tokens
Tokens.EOF      = 0

-- One-character tokens
Tokens.AT       = Tokens.EOF + 1        -- @
Tokens.LBRACE   = Tokens.AT + 1         -- {
Tokens.RBRACE   = Tokens.LBRACE + 1     -- }
Tokens.EQ       = Tokens.RBRACE + 1     -- =
Tokens.COMMA    = Tokens.EQ + 1         -- ,
Tokens.QUOTE    = Tokens.COMMA + 1      -- "
Tokens.HASH     = Tokens.QUOTE + 1      -- #

-- Identifiers and strings (tokens with not only a class but a value)
Tokens.STRING   = Tokens.HASH + 1       -- "fubar" or {fubar} (with nested {})
Tokens.IDENT    = Tokens.STRING + 1     -- foo

