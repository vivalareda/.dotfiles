; Keywords
"MET MOI CA ICITTE" @keyword
"TOKEBEC" @keyword.return
"AMETON QUE" @keyword.conditional
"SINON LA" @keyword.conditional
"JAI JAMAIS TOUCHER A MES FILLES" @keyword.function
"SAUF UNE FOIS AU CHALET" @keyword.function
(print_keyword) @function.builtin

; Comments
(comment) @comment

; Literals
(integer_literal) @number
(string_literal) @string
(boolean_literal) @boolean

; Generic fallback
(identifier) @variable

; Specific identifier roles
(let_statement
  name: (identifier) @function
  value: (function_literal))

(parameter_list
  (parameter name: (identifier) @variable.parameter))

(call_expression
  function: (identifier) @function.call)

(call_expression
  function: (builtin_keyword) @function.builtin)

; Types
(type) @type.builtin

; Operators
["+" "-" "*" "/" "<" ">" "==" "!=" "!" "=" "->"] @operator

; Punctuation
["(" ")" "{" "}" "[" "]"] @punctuation.bracket
["," ":"] @punctuation.delimiter
[";"] @punctuation.delimiter
