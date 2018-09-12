%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(char* s);
void yyerrorMSG(char *msg);
extern int yylex();
%}

//used to define type of value stored in tokens
%union {
  char* sval;
}

%token EOLTOKEN
%token<sval> ROMANTOKEN NAMETOKEN IDENTIFIERTOKEN NAME_INITIAL_TOKEN SRTOKEN JRTOKEN COMMATOKEN DASHTOKEN HASHTOKEN INTTOKEN
%type<sval> postal_addresses address_block name_part personal_part last_name suffix_part street_name location_part town_name state_code street_address street_number zip_code
%%
postal_addresses: address_block EOLTOKEN postal_addresses		{;}
		| address_block			                        {;}
;
address_block: name_part street_address location_part			{;}

location_part: town_name COMMATOKEN state_code zip_code EOLTOKEN        {;}
	     | error EOLTOKEN                                           {yyerrorMSG("location_part"); yyerrok;}
;

name_part: personal_part last_name suffix_part EOLTOKEN			{;}
	 | personal_part last_name EOLTOKEN    	 		        {;}
	 | error EOLTOKEN	   					{yyerrorMSG("name_part");}   	   	     				
;		    
personal_part: NAMETOKEN						{fprintf(stderr, "<FirstName>%s</FirstName>\n", $1);}
	     | NAME_INITIAL_TOKEN				        {fprintf(stderr, "<FirstName>%s</FirstName>\n", $1);}
;

last_name: NAMETOKEN							{fprintf(stderr, "<LastName>%s</LastName>\n", $1);}
;
suffix_part: SRTOKEN							{fprintf(stderr, "<Suffix>%s</Suffix>\n", $1);}
	   | JRTOKEN					 	        {fprintf(stderr, "<Suffix>%s</Suffix>\n", $1);}
	   | ROMANTOKEN					                {fprintf(stderr, "<Suffix>%s</Suffix>\n", $1);}
;
street_address:street_number street_name INTTOKEN EOLTOKEN		{fprintf(stderr, "<AptNum>%d</AptNum>\n", atoi($3));}
	      |street_number street_name HASHTOKEN INTTOKEN EOLTOKEN	{fprintf(stderr, "<AptNum>%d</AptNum>\n", atoi($4));}
	      |street_number street_name EOLTOKEN  	                {;}
	      |error EOLTOKEN	    			                {yyerrorMSG("street_address");yyerrok;}	    			
;

street_number: INTTOKEN							{fprintf(stderr, "<HouseNumber>%d</HouseNumber>\n", atoi($1));}
	     | IDENTIFIERTOKEN	  				        {fprintf(stderr, "<HouseNumber>%s</HouseNumber>\n", $1);}
;
street_name: NAMETOKEN							{fprintf(stderr, "<StreetName>%s</StreetName>\n", $1);}
;
town_name: NAMETOKEN							{fprintf(stderr, "<City>%s</City>\n", $1);}
;
state_code: NAMETOKEN							{fprintf(stderr, "<State>%s</State>\n", $1);}
;
zip_code: INTTOKEN DASHTOKEN INTTOKEN                                   {fprintf(stderr, "<Zip5>%d</Zip5>\n<Zip4>%d</Zip4>\n\n", atoi($1), atoi($3));}
 	| INTTOKEN                                                      {fprintf(stderr, "<Zip5>%d</Zip5>\n\n", atoi($1));}
;

%%
//used to print custom error message
void yyerrorMSG(char *msg)
{
  fprintf(stdout,"Bad %s ...skipping to next line.\n", msg);
}

void yyerror(char* s)
{
  ;
}
