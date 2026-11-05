# Interprete de fichas de MMA con LEX y YACC

Lee un programa sencillo y muestra la ficha de cada peleador, con su
record, su categoria segun el peso y porcentajes de victorias y finalizaciones.

## Lenguaje

    peleador "Nombre" peso 155;
    victoria ko 5;
    victoria sumision 3;
    victoria decision 7;
    derrota 2;
    empate 1;
    ficha;

## Correr

    make
    ./mma ejemplos/peleadores.mma

## Docker

    docker build -t mma-interprete .
    docker run --rm mma-interprete
