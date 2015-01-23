#include "token.h"
#include <stdlib.h>
#include <stdio.h>
//#include "lex.yy.c"

char **string_buff;

char output[100][20]={"EOFtoken", "SEMItoken", "COLONtoken", "COMMAtoken",
     "DOTtoken", "LPARENtoken", "RPARENtoken", "LTtoken", 
     "GTtoken", "EQtoken", "MINUStoken",
     "PLUStoken", "TIMEStoken", "DOTDOTtoken", 
     "COLEQtoken", "LEtoken", "GEtoken", "NEtoken",
     "IDtoken", "ICONSTtoken", "FCONSTtoken", "CCONSTtoken", 
     "SCONSTtoken", "ANDtoken", "ARRAYtoken", "BEGINtoken",
     "CONSTtoken", "DIVIDEtoken",
     "DOWNTOtoken", "INTtoken", "ELSEtoken",
     "ELSIFtoken", "ENDtoken", "ENDIFtoken", 
     "ENDLOOPtoken", "ENDRECtoken",
     "EXITtoken", "FORtoken", "FORWARDtoken", 
     "FUNCTIONtoken", "IFtoken", "IStoken",
     "LOOPtoken", "NOTtoken", "OFtoken", 
     "ORtoken", "PROCEDUREtoken", "PROGRAMtoken",
     "RECORDtoken", "REPEATtoken", "FLOATtoken", "RETURNtoken", 
     "THENtoken", "TOtoken", "TYPEtoken",
     "UNTILtoken", "VARtoken", "WHILEtoken",
     "PRINTtoken"};

main()
{
	int i;
  int j;
  int length;
  char *str;

  string_buff = malloc( TABLE_SZ * sizeof(char*) );

	while ( ( i = yylex() ) != EOFnumber ) {
		switch(i) {
			case IDnumber :
        str = string_buff[yylval.semantic_value];

        while ( *(str) ) {
          if (*str >= 97 && *str <= 122)
            *str -= 32;

          str++;
        }

				printf("%14s, %s\n", 
				output[i], string_buff[yylval.semantic_value]);
				break;

			case SCONSTnumber:
				printf("%14s, string='", output[i]);

        str = string_buff[yylval.semantic_value];
        length = (strl(str));

        for (j = 0; j < length; ++j) {
          if (str[j] == '\\') {
            if (str[ (j + 1) ] == 'n')
              printf("\n");
            if (str[ (j + 1) ] == 't')
              printf("\t");
            if (str[ (j + 1) ] == '\'')
              printf("'");

            j++;
          }
          else
            printf("%c", str[j]);
        }
        printf("'\n");

				break;

			case ICONSTnumber :
				printf("%14s, %d\n",output[i],yylval.semantic_value);
				break;

			case FCONSTnumber :
				printf("%14s, %f\n",output[i],yyval.fvalue);
				break;

			case CCONSTnumber :
				printf("%14s, ", output[i]);

				switch(yylval.semantic_value) {
					case '\n' : printf("%s\n", "'\\n'"); break;
					case '\t' : printf("%s\n", "'\\t'"); break;
					case '\\' : printf("%s\n", "'\\\\'"); break;
					case '\'' : printf("%s\n", "'\\''"); break;
					default : printf("'%s'\n",  string_buff[yylval.semantic_value]); 
				}
				break;

			default :
				printf("%14s\n",output[i]);
	}

	}
	printf("%14s\n","EOFtoken");
}

int
strl(const char *str)
{
  const char *s;
  for (s = str; *s; ++s);
  return(s - str);
}
