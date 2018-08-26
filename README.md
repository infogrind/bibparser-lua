# BibTeX parser in Lua

A minimal parser for BibTeX files, both to do something useful to them (e.g.
pretty printing) and to showcase Lua's capabilities to implement a syntax
parser.

## Getting Started

The script reads input from standard input. Most simple usage in a Lua script:

    require("charreader")
    require("scanner")
    require("parser")

    macros, entries = parser(scanner(charreader()))

Then run the script as

    lua myscript.lua < bibfile.bib

For a more detailed example, see `test_parser.lua`.

### Prerequisites

Lua 5.0 or 5.1 is required. Newer versions will probably break the current code, due to
missing backwards compatibility. (Lua 5.3 will pretty surely not work.)

### Installing

Clone the project from here.

## Running the tests

Simple tests:

- `lua test_parser.lua < bibfile.bib` – simple parser illustration
- `lua test_parsetree.lua < bibfile.bib` – pretty printing syntax tree
- `lua test_scanner.lua < bibfile.bib` – shows the scanner (tokenizer) output
- `lua test_charreader.lua < bibfile.bib` – shows the char reader output

