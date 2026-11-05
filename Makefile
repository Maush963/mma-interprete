mma: mma.tab.c lex.yy.c
	gcc -o mma mma.tab.c lex.yy.c

mma.tab.c mma.tab.h: mma.y
	bison -d mma.y

lex.yy.c: mma.l mma.tab.h
	flex mma.l

clean:
	rm -f mma mma.tab.c mma.tab.h lex.yy.c
