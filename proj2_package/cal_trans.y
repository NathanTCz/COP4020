%{

#include <stdio.h>
#include <stdlib.h>
FILE *outfile;

#define TRUE 1
#define FALSE 0

struct table {
  int vvv;
  char sss[1000];
  int init;
} tbl[1000];

int i = 0;
int final_value = 0;

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

%token EOFnumber 0
%token SEMInumber 1 
%token COLONnumber 2 
%token COMMAnumber 3
%token DOTnumber 4 
%token LPARENnumber 5 
%token RPARENnumber 6
%token LTnumber 7
%token GTnumber 8
%token EQnumber  9
%token MINUSnumber 10 
%token PLUSnumber 11
%token TIMESnumber 12
%token DOTDOTnumber 13
%token COLEQnumber 14
%token LEnumber 15
%token GEnumber 16
%token NEnumber 17
%token <attr> IDnumber 18 
%token <attr> ICONSTnumber 19 
%token FCONSTnumber 20
%token CCONSTnumber 21
%token SCONSTnumber 22
%token ANDnumber 23
%token ARRAYnumber 24
%token BEGINnumber 25
%token CONSTnumber 26
%token DIVnumber 27
%token DOWNTOnumber 28
%token INTnumber 29
%token ELSEnumber 30
%token ELSIFnumber 31
%token ENDnumber 32
%token ENDIFnumber 33
%token ENDLOOPnumber 34
%token ENDRECnumber 35
%token EXITnumber 36
%token FORnumber 37
%token FORWARDnumber 38 
%token FUNCTIONnumber 39
%token IFnumber 40
%token ISnumber 41
%token LOOPnumber 42
%token NOTnumber 43
%token OFnumber 44
%token ORnumber 45
%token PROCEDUREnumber 46
%token PROGRAMnumber 47
%token RECORDnumber 48
%token REPEATnumber 49
%token FLOATnumber 50
%token RETURNnumber 51
%token THENnumber 52
%token TOnumber 53
%token TYPEnumber 54
%token UNTILnumber 55
%token VARnumber 56
%token WHILEnumber 57
%token <attr> PRINTnumber 58

%type <attr> statement
%type <attr> compound_statement
%type <attr> declaration
%type <attr> exp
%type <attr> dec_list
%type <attr> factor

%left PLUSnumber MINUSnumber
%left TIMESnumber DIVnumber
%right EQnumber

%%   /* specification */

program: PROGRAMnumber IDnumber ISnumber compound_statement
  ;

compound_statement: BEGINnumber {print_header();} compound_statement ENDnumber {print_end();}
  | statement {print_other_shit($1.s);} SEMInumber compound_statement

  | statement
  {
    strcpy($$.s, $1.s);
  }

statement: IDnumber EQnumber exp
  {
    sprintf($$.s, "%s = %s", $1.s, $3.s);

    if ( !strcmp(tbl[ $1.s[0] ].sss, $1.s) ) {
      tbl[ $1.s[0] ].vvv = $3.v;
      tbl[ $1.s[0] ].init = TRUE;
    }
    else {
      printf("error line %d: variable \'%s\' has not been declared.\n", yyline, $1.s);
      exit(1);
    }
  }

  | PRINTnumber exp
  {
    printf("%d\n", $2.v);
    print_exp($2.s);
  }

  | declaration
  {
    strcpy($$.s, $1.s);
  }

declaration: VARnumber dec_list
  {
    sprintf($$.s, "int %s", $2.s);
  }

dec_list: IDnumber
  {
    if ( !strcmp(tbl[ $1.s[0] ].sss, "") ) {
      strcpy(tbl[ $1.s[0] ].sss, $1.s);
      tbl[ $1.s[0] ].init = FALSE;
    }
    else {
      printf("error line %d: variable \'%s\' has already been declared.\n", yyline, $1.s);
      exit(1);
    }

    strcpy($$.s, $1.s);
  }

  | dec_list COMMAnumber IDnumber
  {
    if ( !strcmp(tbl[ $3.s[0] ].sss, "") ) {
      strcpy(tbl[ $3.s[0] ].sss, $3.s);
      tbl[ $1.s[0] ].init = FALSE;
    }
    else {
      printf("error line %d: variable \'%s\' has already been declared.\n", yyline, $3.s);
      exit(1);
    }

    sprintf($$.s, "%s, %s", $1.s, $3.s);
  }

exp: exp PLUSnumber exp
  {
    $$.v = ( $1.v + $3.v );
    sprintf($$.s, "%s + %s", $1.s, $3.s);
  }

  | exp MINUSnumber exp
  {
    $$.v = ( $1.v - $3.v );
    sprintf($$.s, "%s - %s", $1.s, $3.s);
  }

  | exp TIMESnumber exp
  {
    $$.v = ( $1.v * $3.v );
    sprintf($$.s, "%s * %s", $1.s, $3.s);
  }

  | exp DIVnumber exp
  {
    if ($3.v == 0) {
      printf("error line %d: %s is zero. cannot divide by zero.\n", yyline, $3.s);
      exit(1);
    }

    $$.v = ( $1.v / $3.v );
    sprintf($$.s, "%s / %s", $1.s, $3.s);
  }

  | MINUSnumber exp %prec MINUSnumber
  {
    $$.v = ( 0 - $2.v );
    sprintf($$.s, "-%s", $2.s);
  }

  | factor
  {
    $$.v = $1.v;
    strcpy($$.s, $1.s);
  }

/*
term: factor
  {
    $$.v = $1.v;
    strcpy($$.s, $1.s);
  }

  | factor DIVnumber term
  {
    $$.v = ( tbl[ $1.s[0] ].vvv / tbl[ $3.s[0] ].vvv );
    sprintf($$.s, "%s / %s", $1.s, $3.s);
  }

  | factor TIMESnumber term
  {
    $$.v = ( tbl[ $1.s[0] ].vvv * tbl[ $3.s[0] ].vvv );
    sprintf($$.s, "%s * %s", $1.s, $3.s);
  }*/

factor: ICONSTnumber
  {
    $$.v = $1.v;
    sprintf($$.s, "%s", $1.s);
  }

  | IDnumber
  {
    if ( tbl[ $1.s[0] ].init == FALSE) {
      printf("error line %d: variable \'%s\' has not been initialized.\n", yyline, $1.s);
      exit(1);
    }
    else
      $$.v = tbl[ $1.s[0] ].vvv;

    strcpy($$.s, $1.s);
  }

  | LPARENnumber exp RPARENnumber
  {
    $$.v = $2.v;
    sprintf($$.s, "( %s )", $2.s);
  }

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

void print_other_shit(const char * s)
{
  fprintf(outfile, "  %s;\n", s);
}

void yyerror(const char *str)
{    printf("yyerror: %s at line %d column: %d\n", str, yyline, yycolumn);
}

int yyparse();

main()
{
  if (!yyparse()) {printf("accept\n");}
  else printf("reject\n");
}  