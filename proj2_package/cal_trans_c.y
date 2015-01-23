/* this file define all teh integer values corresponse with 
 * each type of token.
 */
%{
#include <stdio.h>
FILE *outfile;

%}


/* a simple calculator */

%union {
  int sv;
  float fv;
  struct {
    int v;
    char s[1000];
  } attr;
}

%token   EOFnumber             0
%token   STRINGCONST           1
%token   <sv> INTEGERCONST          2
%token   CHARCONST             3
%token   PLUSNUM               4
%token   TIMESNUM              5
%token   IFNUM                 6
%token   THENNUM               7
%token   ELSENUM               8
%token   EQUALNUM              9
%token   IDNUM                 10
%token   LPARENNUM             11
%token   RPARENNUM             12
%token   SEMINUM               14
%token   BEGINNUM              17
%token   ENDNUM                18


%type <attr> exp
%type <attr> term
%type <attr> item

%%   /* specification */

program: BEGINNUM {print_header();} explist ENDNUM {print_end();}

explist: exp {printf("%d\n",  $1.v); print_exp($1.s);}
       | exp {printf("%d\n",  $1.v); print_exp($1.s);} SEMINUM explist


exp : exp PLUSNUM term
{ 
  $$.v = $1.v + $3.v;
  sprintf($$.s, "%s + %s", $1.s, $3.s);
}
    | term
{
  $$.v = $1.v;
  strcpy($$.s, $1.s);
}
    ;
term : term TIMESNUM item
{
 $$.v = $1.v * $3.v;
 sprintf($$.s, "(%s) * (%s)", $1.s, $3.s);
}
     | item
{
  $$.v = $1.v; strcpy($$.s, $1.s);}
     ;
item : LPARENNUM exp RPARENNUM
{
  $$.v = $2.v; strcpy($$.s , $2.s);
}
    | INTEGERCONST
{
  $$.v = $1; sprintf($$.s, "%d", $1); 
}
    ;
%%


#include "lex.yy.c"
#include <stdio.h>


void print_header()
{
  if ((outfile = fopen("mya.cpp", "w")) == NULL) {
    printf("Can't open file mya.cpp.\n");
    exit(0);
  }

  fprintf(outfile, "#include <iostream>\n");
  fprintf(outfile, "#include <stdio.h>\n");
  fprintf(outfile, "using namespace std;\n");
  fprintf(outfile, "\nmain()\n");
  fprintf(outfile, "{\n");
}

void print_end()
{
  fprintf(outfile, "}\n");
  fclose(outfile);
}

void print_exp(const char * s)
{
  fprintf(outfile, "  cout << %s << \"\\n\";\n", s);
}

void yyerror(const char *str)
{    printf("yyerror: %s at line %d\n", str, yyline);
}

int yyparse();

main()
{
  if (!yyparse()) {printf("accept\n");}
  else printf("reject\n");
}  