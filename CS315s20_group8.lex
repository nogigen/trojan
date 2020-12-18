/* trojan.l */
oneOrMoreSpace      ([ ]|\t)+
zeroOrMoreSpace     ([ ]|\t)*
alphabetic          [a-zA-Z]
bool                (true|false)
digit               [0-9]
integer             [0-9]+
double              ([0-9]*\.[0-9]+)
number		    ({integer}|{double})
string              \"[^\"]*\"
type                (int|float|str|bool|mix|SET{oneOrMoreSpace}int|SET{oneOrMoreSpace}float|SET{oneOrMoreSpace}str|SET{oneOrMoreSpace}bool|SET{oneOrMoreSpace}mix)
setRelationKeys     (subset|superset|equalset|differenceset|equalset)
setOperatorKeys     (union|intersection|addition|multiply|subtract|division)
setFunctions        ({setRelationKeys}|{setOperatorKeys}|create|delete)
builtInFunctions    ({setFunctions}|readFromFile|{variableName}.writeToFile|{set}.writeToFile|{variableName}.add|{set}.add|{variableName}.pop|{set}.pop|{variableName}.contain|{set}.contain)
reservedKeys        (for|if|else|while|{setRelationKeys}|{setRelationEmpty}|{setOperatorKeys}|{variableName}.add|{set}.add|{variableName}.pop|{set}.pop)
variableNumerics    ({digit}|{alphabetic}|_)
variableName        {alphabetic}{variableNumerics}*
leftComment         (\/\/)
comment             {leftComment}(.)*
setInteger	    (\{{zeroOrMoreSpace}({integer}{zeroOrMoreSpace},{zeroOrMoreSpace})*({integer}{zeroOrMoreSpace})?\})	
setFloat	    (\{{zeroOrMoreSpace}({double}{zeroOrMoreSpace},{zeroOrMoreSpace})*({double}{zeroOrMoreSpace})?\})	
setBool	 	    (\{{zeroOrMoreSpace}({bool}{zeroOrMoreSpace},{zeroOrMoreSpace})*({bool}{zeroOrMoreSpace})?\})
setString	    (\{{zeroOrMoreSpace}({string}{zeroOrMoreSpace},{zeroOrMoreSpace})*({string}{zeroOrMoreSpace})?\})	
setVariable	    (\{{zeroOrMoreSpace}({variableName}{zeroOrMoreSpace},{zeroOrMoreSpace})*({variableName}{zeroOrMoreSpace})?\})
set		    ({setInteger}|{setFloat}|{setBool}|{setString})
allVals		    ({string}|{bool}|{integer}|{double}|{set})
functionType	    ({type}|void)
call_func 	    (\${variableNumerics}*{zeroOrMoreSpace})
parameters          ({zeroOrMoreSpace}({variableName}|{allVals}|{builtInFunctions}|{call_func}){zeroOrMoreSpace},{zeroOrMoreSpace})*({variableName}|{allVals}|{builtInFunctions}|{call_func})?

%%
\n		          																{extern int lineno; lineno++;}
\t			  																{;}
{oneOrMoreSpace}         					 											{;}
return																			{return(RETURN);}
{builtInFunctions}      																{return(BUILT_IN_FUNC);} 
\.                        																{return(DOT);}
\,			  																{return(COMMA);}
\;                       																{return(SEMICOLON);}
{bool}                   																{return(BOOL);}
{string}                  																{return(STRING);}
if                  																	{return(IF);}
else                 																	{return(ELSE);}
while                 																	{return(WHILE);}
for        	                     															{return(FOR);}
{functionType}{oneOrMoreSpace}func{oneOrMoreSpace}\${variableNumerics}*											{return(DEFINE_FUNC);}
\${variableNumerics}*{zeroOrMoreSpace}     														{return(CALL_FUNC);}
int{oneOrMoreSpace}{variableName}															{return(INT_DECLARATION_or1parameter);}
float{oneOrMoreSpace}{variableName}															{return(FLOAT_DECLARATION_or1parameter);}
str{oneOrMoreSpace}{variableName}															{return(STR_DECLARATION_or1parameter);}
bool{oneOrMoreSpace}{variableName}															{return(BOOL_DECLARATION_or1parameter);}
SET{oneOrMoreSpace}int{oneOrMoreSpace}{variableName}													{return(SET_INT_DECLARATION_or1parameter);}
SET{oneOrMoreSpace}float{oneOrMoreSpace}{variableName}													{return(SET_FLOAT_DECLARATION_or1parameter);}
SET{oneOrMoreSpace}str{oneOrMoreSpace}{variableName}													{return(SET_STR_DECLARATION_or1parameter);}
SET{oneOrMoreSpace}bool{oneOrMoreSpace}{variableName}													{return(SET_BOOL_DECLARATION_or1parameter);}
{variableName}            																{return(VARIABLE);}
{comment}                 																{return(COMMENT);}
{integer}                 																{return(INTEGER);}
{double}                  																{return(FLOAT);}
\(                        																{return(LP);}
\)                        																{return(RP);}
\{                       																{return(LB);}
\}                       																{return(RB);}
\+                       																{return(PLUS);}
\-                       			 													{return(MINUS);}
\*                       																{return(TIMES);}
\/                       																{return(DIVIDE);}
\!=                      																{return(NOT_EQ);}
\<=                       																{return(LESS_EQ);}
\>=                      																{return(GREATER_EQ);}
\>                       																{return(GREATER);}
\<                       																{return(LESS);}
\=                      			  													{return(ASSIGN_OP);}
\:                       			 													{return(COLON);}
\=\=                     			 													{return(EQUAL_OP);}
\&\&                      																{return(AND_LOGIC);}
\|\|                     																{return(OR_LOGIC);}
{setInteger}																				{return(SET_INTEGER);}
{setFloat}																				{return(SET_FLOAT);}
{setBool}																				{return(SET_BOOL);}
{setString}																				{return(SET_STRING);}
{setVariable}																				{return(SET_VARIABLE);}
({type}{oneOrMoreSpace}{variableName}{zeroOrMoreSpace},{zeroOrMoreSpace})*({type}{oneOrMoreSpace}{variableName})?					{return(DEFINE_PARAMETERS);}
({zeroOrMoreSpace}({variableName}|{allVals}|{builtInFunctions}\({parameters}\)|{call_func}\({parameters}\)){zeroOrMoreSpace},{zeroOrMoreSpace})*({variableName}|{allVals}|{builtInFunctions}|{call_func})?	{return(CALL_PARAMETERS);}

%%
int yywrap() { return 1; }