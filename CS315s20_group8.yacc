/* troan.y */
%{
#include <stdio.h>
%}

%union{ double   real;
        int   integer; 
        char* string;
}

%token <real> FLOAT
%token <string> STRING
%token <integer> INTEGER
%token RETURN SET_VARIABLE BUILT_IN_FUNC DOT COMMA SEMICOLON BOOL IF ELSE WHILE FOR DEFINE_FUNC CALL_FUNC INT_DECLARATION_or1parameter FLOAT_DECLARATION_or1parameter BOOL_DECLARATION_or1parameter STR_DECLARATION_or1parameter SET_INT_DECLARATION_or1parameter SET_FLOAT_DECLARATION_or1parameter SET_STR_DECLARATION_or1parameter SET_BOOL_DECLARATION_or1parameter VARIABLE COMMENT LP RP LB RB PLUS MINUS TIMES DIVIDE NOT_EQ LESS_EQ GREATER_EQ GREATER LESS ASSIGN_OP COLON EQUAL_OP AND_LOGIC OR_LOGIC SET_INTEGER SET_FLOAT SET_BOOL SET_STRING DEFINE_PARAMETERS CALL_PARAMETERS                       


%left PLUS MINUS
%left TIMES DIVIDE
%left UMINUS

%nonassoc THEN
%nonassoc ELSE
%%

program: statements
{ printf("\n---------syntax is valid!--------\n");}
;

statements: /* empty */
	   | statements statement


statement: assignment SEMICOLON
	 | if_statement
	 | for_statement
	 | while_statement
	 | define_func_statement
	 | functionNum SEMICOLON
         | return_statement SEMICOLON
	 | COMMENT
;

assignment: VARIABLE ASSIGN_OP dumbExpr
	   | VARIABLE ASSIGN_OP conditions
	   | VARIABLE ASSIGN_OP setIntExpr
	   | VARIABLE ASSIGN_OP setFloatExpr
	   | VARIABLE ASSIGN_OP setStrExpr
	   | VARIABLE ASSIGN_OP setBoolExpr

	   | INT_DECLARATION_or1parameter ASSIGN_OP intExpr
	   | INT_DECLARATION_or1parameter ASSIGN_OP noTypeExpr
           | FLOAT_DECLARATION_or1parameter ASSIGN_OP floatExpr
	   | FLOAT_DECLARATION_or1parameter ASSIGN_OP noTypeExpr
	   | STR_DECLARATION_or1parameter ASSIGN_OP strExpr
	   | STR_DECLARATION_or1parameter ASSIGN_OP noTypeExpr
	   | BOOL_DECLARATION_or1parameter ASSIGN_OP boolExpr

	   | SET_INT_DECLARATION_or1parameter ASSIGN_OP setIntExpr
	   | SET_INT_DECLARATION_or1parameter ASSIGN_OP noTypeExpr
	   | SET_FLOAT_DECLARATION_or1parameter ASSIGN_OP setFloatExpr
	   | SET_FLOAT_DECLARATION_or1parameter ASSIGN_OP noTypeExpr
	   | SET_STR_DECLARATION_or1parameter ASSIGN_OP setStrExpr
	   | SET_STR_DECLARATION_or1parameter ASSIGN_OP noTypeExpr
	   | SET_BOOL_DECLARATION_or1parameter ASSIGN_OP setBoolExpr
	   | SET_BOOL_DECLARATION_or1parameter ASSIGN_OP noTypeExpr
   ;

define_parameters: /* nothing */
		 | DEFINE_PARAMETERS | INT_DECLARATION_or1parameter | FLOAT_DECLARATION_or1parameter
		 | STR_DECLARATION_or1parameter | BOOL_DECLARATION_or1parameter | SET_INT_DECLARATION_or1parameter
	   	 | SET_FLOAT_DECLARATION_or1parameter | SET_STR_DECLARATION_or1parameter | SET_BOOL_DECLARATION_or1parameter
		;
define_func_statement: DEFINE_FUNC LP define_parameters RP LB statements RB
;

parameters: /* empty */
	   | CALL_PARAMETERS | INTEGER | FLOAT | STRING | VARIABLE | SET_INTEGER | SET_FLOAT | SET_BOOL | SET_STRING | SET_VARIABLE
;

functionNum: BUILT_IN_FUNC LP parameters RP
  	    | CALL_FUNC LP parameters RP	 
;

return_statement: RETURN | RETURN intExpr | RETURN noTypeExpr | RETURN floatExpr |RETURN  strExpr | RETURN setIntExpr | RETURN setFloatExpr | RETURN setStrExpr | RETURN setBoolExpr
;

expr: intExpr | floatExpr | strExpr | noTypeExpr
;

dumbExpr: intExpr | floatExpr | strExpr
;


noTypeExpr: functionNum | VARIABLE | SET_VARIABLE
	 | noTypeExpr PLUS noTypeExpr
	 | noTypeExpr MINUS noTypeExpr
	 | noTypeExpr TIMES noTypeExpr
	 | noTypeExpr DIVIDE noTypeExpr
	 | MINUS noTypeExpr %prec UMINUS
	 | LP noTypeExpr RP
;

logics: AND_LOGIC | OR_LOGIC
;
cond_idents: LESS_EQ | GREATER_EQ | GREATER | LESS | EQUAL_OP | NOT_EQ
;

condition: LP expr cond_idents expr RP |LP condition logics condition RP | expr cond_idents expr | noTypeExpr | BOOL
;

conditions: condition | condition logics conditions

if_statement: IF LP conditions RP LB statements RB           %prec THEN
   	    | IF LP conditions RP LB statements RB ELSE LB statements RB
;


for_statement: FOR LP assignment SEMICOLON conditions SEMICOLON assignment RP LB statements RB
;


while_statement: WHILE LP conditions RP LB statements RB
;



setIntExpr: SET_INTEGER
	| setIntExpr PLUS setIntExpr
	| setIntExpr MINUS setIntExpr
	| setIntExpr TIMES setIntExpr
	| setIntExpr DIVIDE setIntExpr

	| noTypeExpr PLUS setIntExpr
	| noTypeExpr MINUS setIntExpr
	| noTypeExpr TIMES setIntExpr
	| noTypeExpr DIVIDE setIntExpr

	| setIntExpr PLUS noTypeExpr
	| setIntExpr MINUS noTypeExpr
	| setIntExpr TIMES noTypeExpr
	| setIntExpr DIVIDE noTypeExpr

	| MINUS setIntExpr %prec UMINUS
	| LP setIntExpr RP
;

intExpr: INTEGER
	| intExpr PLUS intExpr
	| intExpr MINUS intExpr
	| intExpr TIMES intExpr
	| intExpr DIVIDE intExpr

	| noTypeExpr PLUS intExpr
	| noTypeExpr MINUS intExpr
	| noTypeExpr TIMES intExpr
	| noTypeExpr DIVIDE intExpr

	| intExpr PLUS noTypeExpr
	| intExpr MINUS noTypeExpr
	| intExpr TIMES noTypeExpr
	| intExpr DIVIDE noTypeExpr

	| MINUS intExpr %prec UMINUS
	| LP intExpr RP
;


setFloatExpr: SET_FLOAT
	| setFloatExpr PLUS setFloatExpr
	| setFloatExpr MINUS setFloatExpr
	| setFloatExpr TIMES setFloatExpr
	| setFloatExpr DIVIDE setFloatExpr
	| MINUS setFloatExpr %prec UMINUS
	| LP setFloatExpr RP

	| setFloatExpr PLUS setIntExpr
	| setFloatExpr MINUS setIntExpr
	| setFloatExpr TIMES setIntExpr
	| setFloatExpr DIVIDE setIntExpr

	| setIntExpr PLUS setFloatExpr
	| setIntExpr MINUS setFloatExpr
	| setIntExpr TIMES setFloatExpr
	| setIntExpr DIVIDE setFloatExpr

	| noTypeExpr PLUS setFloatExpr
	| noTypeExpr MINUS setFloatExpr
	| noTypeExpr TIMES setFloatExpr
	| noTypeExpr DIVIDE setFloatExpr

	| setFloatExpr PLUS noTypeExpr
	| setFloatExpr MINUS noTypeExpr
	| setFloatExpr TIMES noTypeExpr
	| setFloatExpr DIVIDE noTypeExpr


floatExpr: FLOAT
	| floatExpr PLUS floatExpr
	| floatExpr MINUS floatExpr
	| floatExpr TIMES floatExpr
	| floatExpr DIVIDE floatExpr
	| MINUS floatExpr %prec UMINUS
	| LP floatExpr RP

	| floatExpr PLUS intExpr
	| floatExpr MINUS intExpr
	| floatExpr TIMES intExpr
	| floatExpr DIVIDE intExpr

	| intExpr PLUS floatExpr
	| intExpr MINUS floatExpr
	| intExpr TIMES floatExpr
	| intExpr DIVIDE floatExpr

	| noTypeExpr PLUS floatExpr
	| noTypeExpr MINUS floatExpr
	| noTypeExpr TIMES floatExpr
	| noTypeExpr DIVIDE floatExpr

	| floatExpr PLUS noTypeExpr
	| floatExpr MINUS noTypeExpr
	| floatExpr TIMES noTypeExpr
	| floatExpr DIVIDE noTypeExpr
;

setStrExpr: SET_STRING
	| setStrExpr PLUS setStrExpr
	| noTypeExpr PLUS setStrExpr
	| setStrExpr PLUS noTypeExpr
        | LP setStrExpr RP 
;

strExpr: STRING
        | strExpr PLUS strExpr
	| noTypeExpr PLUS strExpr
	| strExpr PLUS noTypeExpr
        | LP strExpr RP 
;

setBoolExpr: SET_BOOL
;

boolExpr: conditions
;

%%
#include "lex.yy.c"
int lineno;

main() {
    
  return yyparse();
}

yyerror( char *s ) { fprintf( stderr, "%s in line number: %d\n", s, (lineno + 1)); };

