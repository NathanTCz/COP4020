a.out: lex.yy.o driver.o
	gcc lex.yy.o driver.o -lfl
lex.yy.o: analysis.l
	flex analysis.l
	gcc -c lex.yy.c
main.o: driver.c
	gcc -c driver.c
clean:
	rm -f *.o
	rm -f lex.yy.c
	rm -f *~
	rm -f #*#
	rm -f core*
	rm -f a.out