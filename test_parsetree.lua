require("charreader")
require("scanner")
require("parsetree")
require("printvisitor")

tree = parser(scanner(charreader("mkbiblio.bib")))
v = print_visitor()
v:visit(tree)
