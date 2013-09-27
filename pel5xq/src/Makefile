
all: turtle eins.ps

eins.ps: eins.tlt turtle
	./turtle < eins.tlt > eins.ps

lex.yy.o:  lex.yy.c turtle-pel5xq.tab.h symtab.h
	gcc -c lex.yy.c

lex.yy.c: turtle_pel5xq.l
	flex turtle_pel5xq.l
	
turtle-pel5xq.tab.h: turtle-pel5xq.y
	bison -d turtle-pel5xq.y
	
turtle-pel5xq.tab.c: turtle-pel5xq.y
	bison -d turtle-pel5xq.y
	
turtle-pel5xq.tab.o: turtle-pel5xq.tab.c symtab.h
	gcc -c turtle-pel5xq.tab.c

turtle: turtle-pel5xq.tab.o lex.yy.o symtab.c
	gcc lex.yy.o turtle-pel5xq.tab.o symtab.c -lfl -o turtle

clean:
	rm -f turtle lex.* turtle-pel5xq.tab.o *.o eins.ps

