%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex(void);
extern FILE *yyin;
extern int lineno;
void yyerror(const char *s);

typedef struct {
    char nombre[80];
    int  peso;
    int  ko, sumision, decision;
    int  derrotas, empates;
    int  activo;
} Peleador;

static Peleador p;

static const char *categoria(int peso) {
    if (peso <= 115) return "Paja";
    if (peso <= 125) return "Mosca";
    if (peso <= 135) return "Gallo";
    if (peso <= 145) return "Pluma";
    if (peso <= 155) return "Ligero";
    if (peso <= 170) return "Welter";
    if (peso <= 185) return "Medio";
    if (peso <= 205) return "Semipesado";
    return "Pesado";
}

static int hay_peleador(void) {
    if (!p.activo) {
        fprintf(stderr, "Linea %d, primero declara un peleador\n", lineno);
        return 0;
    }
    return 1;
}

static void imprimir_ficha(void) {
    int victorias = p.ko + p.sumision + p.decision;
    int total = victorias + p.derrotas + p.empates;

    printf("\n==============================\n");
    printf(" %s\n", p.nombre);
    printf(" Categoria %s (%d lb)\n", categoria(p.peso), p.peso);
    printf("==============================\n");
    printf(" Record      %d-%d-%d\n", victorias, p.derrotas, p.empates);
    printf(" Por KO      %d\n", p.ko);
    printf(" Por sumision %d\n", p.sumision);
    printf(" Por decision %d\n", p.decision);
    if (total > 0) {
        printf(" Victorias   %.1f%%\n", victorias * 100.0 / total);
    }
    if (victorias > 0) {
        printf(" Finalizadas %.1f%%\n", (p.ko + p.sumision) * 100.0 / victorias);
    }
    printf("==============================\n");
}
%}

%union {
    int   num;
    char *str;
}

%token <num> NUM
%token <str> CADENA
%token PELEADOR PESO VICTORIA DERROTA EMPATE KO SUMISION DECISION FICHA

%%

programa
    : /* vacio */
    | programa sentencia
    ;

sentencia
    : PELEADOR CADENA PESO NUM ';'
        {
            memset(&p, 0, sizeof(p));
            strncpy(p.nombre, $2, sizeof(p.nombre) - 1);
            p.peso = $4;
            p.activo = 1;
            free($2);
        }
    | VICTORIA KO NUM ';'        { if (hay_peleador()) p.ko += $3; }
    | VICTORIA SUMISION NUM ';'  { if (hay_peleador()) p.sumision += $3; }
    | VICTORIA DECISION NUM ';'  { if (hay_peleador()) p.decision += $3; }
    | DERROTA NUM ';'            { if (hay_peleador()) p.derrotas += $2; }
    | EMPATE NUM ';'             { if (hay_peleador()) p.empates += $2; }
    | FICHA ';'                  { if (hay_peleador()) imprimir_ficha(); }
    | error ';'                  { yyerrok; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Linea %d, error de sintaxis\n", lineno);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) { perror(argv[1]); return 1; }
    }
    return yyparse();
}
