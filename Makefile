all: y.tab.c lex.yy.c
	gcc -o p2 y.tab.c
	rm -f lex.yy.c y.tab.c y.output *~
	./p2 < CS315s20_group8.test
y.tab.c: CS315s20_group8.yacc lex.yy.c
	yacc CS315s20_group8.yacc
lex.yy.c: CS315s20_group8.lex
	lex CS315s20_group8.lex