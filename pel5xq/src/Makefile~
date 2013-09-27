
all: turtle eins.ps

eins.ps: eins.tlt turtle
	./turtle < eins.tlt > eins.ps

lex.yy.o:  lex.yy.c turtle.tab.h symtab.h
	gcc -c lex.yy.c

lex.yy.c: turtle_pel5xq.l
	flex turtle_pel5xq.l
	
turtle.tab.h: turtle-pel5xq.y
	bison -d turtle-pel5xq.y
	
turtle.tab.c: turtle-pel5xq.y
	bison -d turtle-pel5xq.y
	
turtle.tab.o: turtle.tab.c symtab.h
	gcc -c turtle.tab.c

turtle: turtle.tab.o lex.yy.o symtab.c
	gcc lex.yy.o turtle.tab.o symtab.c -lfl -o turtle

clean:
	rm -f turtle lex.* turtle.tab.* *.o eins.ps

