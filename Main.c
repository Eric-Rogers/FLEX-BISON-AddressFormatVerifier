#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yyparse(); //allows use of c function made by bison
extern int justLex(); //allows use of c function I defined in flex that is used to just run flex on the file and print to screen what flex matched

int main(int argc, char* argv[])
{
  //check if program called with name scanner
  if(strcmp(argv[0], "./scanner") == 0)
  {
    printf("\nOperating in scan mode\n\n");
    justLex(); //function I defined in flex that just runs lexical analysis
  }
  else
  {
    printf("\nOperating in parse mode\n\n");

    int check = yyparse();

    switch(check)
    {
    case 0 : printf("\nParse successful!\n");
             fflush(stdout);
             break;
    case 1 : printf("Parse error!\n");
             break;
    default: printf("Undocumented Error\n"); 
             break;
    }
  }

  return 0;
}
