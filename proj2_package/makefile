all: cal_trans_c
cal_trans_c: 
	lex lexer.l
	yacc -v cal_trans.y
	gcc -o run y.tab.c -ll

clean:
	rm -f y.tab.c
	rm -f lex.yy.c
	rm -f run
	rm -f y.output
	rm -f *~
	rm -f a.out
	rm -f mya.cpp
