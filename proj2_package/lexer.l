%{

/* definitions */
#include "token.h"
#include <string.h>

int put_string(char *str, int len);

/* int yylval; */
char string_table[20000];
int string_table_index = 0;
int yyline = 1, yycolumn = 1;

%}

delim [ \t]
ws {delim}+
bksl [^\\].?
letter [a-zA-Z]
digit  [0-9]
id {letter}+({digit})*
number {digit}+
float [-+]?{number}\.{number}([eE][-+]?{number})?

%%
\n                                      {yyline++; yycolumn=1;}
{ws}                                    {yycolumn += yyleng;}

"end of file"                           {yycolumn += yyleng; return (EOFnumber);}
";"                                     {yycolumn += yyleng; return (SEMInumber);}
":"                                     {yycolumn += yyleng; return (COLONnumber);} 
","                                     {yycolumn += yyleng; return (COMMAnumber);}
"."                                     {yycolumn += yyleng; return (DOTnumber);}
"("                                     {yycolumn += yyleng; return (LPARENnumber);}
")"                                     {yycolumn += yyleng; return (RPARENnumber);}
"<"                                     {yycolumn += yyleng; return (LTnumber);}
">"                                     {yycolumn += yyleng; return (GTnumber);}
"="                                     {yycolumn += yyleng; return (EQnumber);}
"-"                                     {yycolumn += yyleng; return (MINUSnumber);}
"+"                                     {yycolumn += yyleng; return (PLUSnumber);}
"*"                                     {yycolumn += yyleng; return (TIMESnumber);}
".."                                    {yycolumn += yyleng; return (DOTDOTnumber);}
":="                                    {yycolumn += yyleng; return (COLEQnumber);}
"<="                                    {yycolumn += yyleng; return (LEnumber);}
">="                                    {yycolumn += yyleng; return (GEnumber);}
"<>"                                    {yycolumn += yyleng; return (NEnumber);}

[Aa][Nn][Dd]                            {yycolumn += yyleng; return (ANDnumber);}
[Aa][Rr][Rr][Aa][Yy]                    {yycolumn += yyleng; return (ARRAYnumber);}
[Bb][Ee][Gg][Ii][Nn]                    {yycolumn += yyleng; return (BEGINnumber);}
[Cc][Oo][Nn][Ss][Tt][Aa][Nn][Tt]        {yycolumn += yyleng; return (CONSTnumber);}
[Dd][Ii][Vv]                            {yycolumn += yyleng; return (DIVnumber);}
[Dd][Oo][Ww][Nn][Tt][Oo]                {yycolumn += yyleng; return (DOWNTOnumber);} 
[Ii][Nn][Tt][Ee][Gg][Ee][Rr]            {yycolumn += yyleng; return (INTnumber);}
[Ee][Ll][Ss][Ee]                        {yycolumn += yyleng; return (ELSEnumber);}
[Ee][Ll][Ss][Ii][Ff]                    {yycolumn += yyleng; return (ELSIFnumber);}
[Ee][Nn][Dd]                            {yycolumn += yyleng; return (ENDnumber);}
[Ee][Nn][Dd][Ii][Ff]                    {yycolumn += yyleng; return (ENDIFnumber);}
[Ee][Nn][Dd][Ll][Oo][Oo][Pp]            {yycolumn += yyleng; return (ENDLOOPnumber);}
[Ee][Nn][Dd][Rr][Ee][Cc]                {yycolumn += yyleng; return (ENDRECnumber);}
[Ee][Xx][Ii][Tt]                        {yycolumn += yyleng; return (EXITnumber);}
[Ff][Oo][Rr]                            {yycolumn += yyleng; return (FORnumber);}
[Ff][Oo][Rr][Ww][Aa][Rr][Dd]            {yycolumn += yyleng; return (FORWARDnumber);}
[Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]        {yycolumn += yyleng; return (FUNCTIONnumber);}
[Ii][Ff]                                {yycolumn += yyleng; return (IFnumber);}
[Ii][Ss]                                {yycolumn += yyleng; return (ISnumber);}
[Ll][Oo][Oo][Pp]                        {yycolumn += yyleng; return (LOOPnumber);}
[Nn][Oo][Tt]                            {yycolumn += yyleng; return (NOTnumber);}
[Oo][Ff]                                {yycolumn += yyleng; return (OFnumber);}
[Oo][Rr]                                {yycolumn += yyleng; return (ORnumber);}
[Pp][Rr][Oo][Cc][Ee][Dd][Uu][Rr][Ee]    {yycolumn += yyleng; return (PROCEDUREnumber);}
[Pp][Rr][Oo][Gg][Rr][Aa][Mm]            {yycolumn += yyleng; return (PROGRAMnumber);}
[Rr][Ee][Cc][Oo][Rr][Dd]                {yycolumn += yyleng; return (RECORDnumber);}
[Rr][Ee][Pp][Ee][Aa][Tt]                {yycolumn += yyleng; return (REPEATnumber);}
[Ff][Ll][Oo][Aa][Tt]                    {yycolumn += yyleng; return (FLOATnumber);}
[Rr][Ee][Tt][Uu][Rr][Nn]                {yycolumn += yyleng; return (RETURNnumber);}
[Tt][Hh][Ee][Nn]                        {yycolumn += yyleng; return (THENnumber); }
[Tt][Oo]                                {yycolumn += yyleng; return (TOnumber);}
[Tt][Yy][Pp][Ee]                        {yycolumn += yyleng; return (TYPEnumber);}
[Uu][Nn][Tt][Ii][Ll]                    {yycolumn += yyleng; return (UNTILnumber);}
[Vv][Aa][Rr]                            {yycolumn += yyleng; return (VARnumber);}
[Ww][Hh][Ii][Ll][Ee]                    {yycolumn += yyleng; return (WHILEnumber);}
[Pp][Rr][Ii][Nn][Tt]                    {yycolumn += yyleng; return (PRINTnumber);}

{id}        {
            yycolumn += yyleng;
            strcpy(yylval.attr.s, yytext);
            //yylval.attr.sv ,put_string(yytext, yyleng);
            return (IDnumber);  
            }        

{float}     {
            yycolumn += yyleng;
            yylval.fv = atof(yytext);
            return (FCONSTnumber);
            }

{number}    {
            strcpy(yylval.attr.s, yytext);
            yylval.attr.v = atoi(yytext);
            yycolumn += yyleng;
            return (ICONSTnumber);
            }



\'(\\.|[^\n\\'])*    {
            int c;
            yycolumn += yyleng;

            if (yyleng == 3) {
              c = input(); /* read the additional ' */

              if (c != '\'') {
                printf("unenclosed character, line = %d, column = %d\n",
                (yyline + 1), (yycolumn - yyleng)
                );

                if (c != 0) unput(c);
              }
              else {
                strcpy(yylval.attr.s, yytext);
                //yylval.attr.sv = put_string( (yytext + 1), (yyleng - 1));
                return(CCONSTnumber);
              }

            } 
            else {
              c = input();
                if (c != '\'') {
                  printf("unended string, line = %d, column = %d\n",
                  (yyline + 1), (yycolumn - yyleng)
                  );

                if (c != 0) unput(c);
              }
              else {
                strcpy(yylval.attr.s, yytext);
                //yylval.attr.sv = put_string( (yytext + 1), (yyleng - 1));
                return(SCONSTnumber);
              }
            }

            }

"(*"        {
            char c1; 
            char c2 = input();

            if(c2 <= 0) {
              printf("Unfinished comment");
            }
            else {
              c1 = c2; 
              c2 = input();

              while(((c1!='*') || (c2 != ')')) && (c2  > 0)) {
                c1 = c2; 
                c2 = input();
              }

              if (c2 <= 0) {
                printf("unended comment, line = %d, column = %d\n",
                (yyline + 2), (yycolumn - yyleng) + 2
                );
              }

              //return (COMMENTnumber);
            }

            }

.           {
            printf("Unknown character '%s', line = %d, column = %d\n", 
            yytext, (yyline + 1), yycolumn
            );

            yycolumn += yyleng;
            }
%%

#include <stdio.h>

int yywrap()
{  if (feof(stdin)) return 1;
   return 0;
}