%option noyywrap
%option nounput
%option noinput

%{
#include<stdlib.h>
#include "y.tab.h"
%}

%%
[ \t]                    ;
Sr["."]                  {yylval.sval = yytext; return SRTOKEN;}
Jr["."]                  {yylval.sval = yytext; return JRTOKEN;}
[0-9]+                   {yylval.sval = yytext; return INTTOKEN;}
[VXL]*[IVX]+[VXL]*       {yylval.sval = yytext; return ROMANTOKEN;}
[a-zA-Z][a-zA-Z]+	 {yylval.sval = yytext; return NAMETOKEN;}
[a-zA-Z0-9][a-zA-Z0-9]+  {yylval.sval = yytext; return IDENTIFIERTOKEN;}
[a-zA-Z]['.']*       	 {yylval.sval = yytext; return NAME_INITIAL_TOKEN;}
\n	      		 {return EOLTOKEN;}	
,	      		 {yylval.sval = yytext; return COMMATOKEN;}
-	      		 {yylval.sval = yytext; return DASHTOKEN;}
#	      		 {yylval.sval = yytext; return HASHTOKEN;}
.			 {return *yytext;}
%%
int justLex()
{
	int hold = yylex();
	char *type = "";

	//yylex() will return zero when reaches end of file, so go until returns 0
	while(hold != 0)
        {
		//using enum value assigned by bison to the token set type to the token's actual name
		switch(hold)
		{
			case EOLTOKEN : type = "EOLTOKEN";
                                   break;
			case ROMANTOKEN : type = "ROMANTOKEN";
			     	   break; 
			case NAMETOKEN : type = "NAMETOKEN";
			     	   break;
			case IDENTIFIERTOKEN : type = "IDENTIFIERTOKEN";
			     	   break;
                        case NAME_INITIAL_TOKEN : type = "NAME_INITIAL_TOKEN";
			     	   break;
			case SRTOKEN : type = "SRTOKEN";
			     	   break;
                        case JRTOKEN : type = "JRTOKEN";
			     	   break;
                        case COMMATOKEN : type = "COMMATOKEN";
			     	   break;
			case DASHTOKEN : type = "DASHTOKEN";
			     	   break;
                        case HASHTOKEN : type = "HASHTOKEN";
			     	   break;
                        case INTTOKEN : type = "INTTOKEN";
			     	   break;
			default : break;
        	}

		printf("yylex returned %s ", type);
		
		//used to make sure it prints nicely with no wierd new lines
		if(strcmp(type, "EOLTOKEN") == 0)
			printf("()\n");
		else
			printf("(%s)\n",yytext);
			
		//move to next match
		hold = yylex();
	}
	return 0;
}
