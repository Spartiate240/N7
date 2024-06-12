
main.o: main.c
	gcc -c main.c -o main.o

test: main.o affine.o
	@echo "Cibles : $@, dépendances : $^
	gcc main.o affine.o -o test

affine.o:
	gcc -c affine.c -o affine.o


