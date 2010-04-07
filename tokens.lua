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

function token_to_string(t, s)
  if t == Tokens.EOF then
    return "EOF"
  elseif t == Tokens.AT then
    return "AT"
  elseif t == Tokens.LBRACE then
    return "LBRACE"
  elseif t == Tokens.RBRACE then
    return "RBRACE"
  elseif t == Tokens.EQ then
    return "EQ"
  elseif t == Tokens.COMMA then
    return "COMMA"
  elseif t == Tokens.QUOTE then
    return "QUOTE"
  elseif t == Tokens.HASH then
    return "HASH"
  elseif t == Tokens.STRING then
      if s ~= nil then
          return "STRING(" .. s .. ")"
      else
          return "STRING"
      end
  elseif t == Tokens.IDENT then
      if s ~= nil then
          return "IDENT(" .. s .. ")"
      else
          return "IDENT"
      end
  else
    return nil
  end
end
