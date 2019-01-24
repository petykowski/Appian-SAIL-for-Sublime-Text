---------
VARIABLES
---------
local!variable
fv!item
ri!isEdit
rf!name
rp!id
tp!instance
pv!user
pp!id
ac!variable
save!value

-----
RULES
-----
rule!EX_getDataByCriteria

---------
CONSTANTS
---------
cons!EX_RECORD_TYPES

-------
STRINGS
-------
"ADJECENT"
'type!{urn:com:appian:types:ex}EX_RECORD_DETAILS'

--------
KEYWORDS
--------
null
true
false

-------
NUMBERS
-------
123
123.456

----------
PARAMETERS
----------
label: "Title"
value: ri!example
required: true

---------
OPERATORS
---------
+
-
*
=

---------
FUNCTIONS
---------
cleanwith( "text string", "xte" )
euro( 13213.43 )
a!forEach(
  items: {"apple", "pear", "banana"},
  expression: "Word " & fv!index & " is length: " & len(fv!item)
)
apply(fn!sum, {-1, 2, 3}, 2)

----------
DEPRECATED
----------
linktoprocessdashboard()
linktofolder()
a!formLayoutColumns()

--------
COMMENTS
--------

/* Single Line Comment */
/*
  Multi-Line
  Comment
*/
cleanwith() /* Inline Comment */

