set -e

mkdir build -p
cd build/
bison -d -o sintatico.tab.c ../src/bison/sintatico.y
flex -o lex.yy.c ../src/flex/lexico.l
gcc lex.yy.c sintatico.tab.c -lfl -o simple-c
cd ..
