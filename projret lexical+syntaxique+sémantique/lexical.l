%{
#include<stdio.h>
#include<stdlib.h>
#include "ess.tab.h"
extern YYSTYPE yylval;
int colonne = 1;
int ligne = 1;
%}
type_Uint  [1-9][0-9]*|0
type_Ufloat ([1-9]+|0)[\.][0-9]+
mot_cle "DEC"|"INST"|"FIN"|"define"|"IF"|"ELSE"|"ENDIF"|"FOR"|"ENDFOR"|"FINIF"
type "Uint"|"Ufloat"

commentaire ^[<][<].*{saut}*.*{saut}*.*[>][>]$
idf [a-z]+[0-9]*[a-z]*([_]+([0-9]|[a-z])+)*
saut [\n]
%%


{mot_cle} {
if(strcmp(yytext,"DEC")==0) {colonne = colonne + yyleng; yylval.chaine=strdup(yytext); return DEC;}
if(strcmp(yytext,"INST")==0) {colonne = colonne + yyleng; yylval.chaine=strdup(yytext); return INST;}
if(strcmp(yytext,"FIN")==0) {colonne = colonne + yyleng; yylval.chaine=strdup(yytext); return FIN;}
if(strcmp(yytext,"define")==0) {colonne = colonne + yyleng; yylval.chaine=strdup(yytext); return define;}
if(strcmp(yytext,"IF")==0) {colonne = colonne + yyleng; yylval.chaine=strdup(yytext); return IF;}
if(strcmp(yytext,"ELSE")==0) {colonne = colonne + yyleng; yylval.chaine=strdup(yytext); return ELSE;}
if(strcmp(yytext,"FOR")==0) {colonne = colonne + yyleng; yylval.chaine=strdup(yytext); return FOR;}
if(strcmp(yytext,"ENDFOR")==0) {colonne = colonne + yyleng; yylval.chaine=strdup(yytext); return ENDFOR;}
if(strcmp(yytext,"FINIF")==0) {colonne = colonne + yyleng; yylval.chaine=strdup(yytext); return FINIF;}}



"Uint" return Uint;
"Ufloat" return Ufloat;
{commentaire} {colonne = colonne+yyleng; return commentaire;}

{idf} {if(yyleng<=7) {colonne = colonne+yyleng; yylval.chaine=strdup(yytext); return idf;}
else {printf("le ' %s ' est trop long comme idf\n",yytext);colonne = colonne+yyleng;}}

{type_Ufloat} {colonne = colonne+yyleng; yylval.reel=atof(yytext); return type_Ufloat;}

{type_Uint} {if(atoi(yytext)<32768) {colonne = colonne+yyleng; yylval.entier=atoi(yytext); return type_Uint;}
else {printf("le mot  ' %s ' est superieur a 32767 donc il n'est pas accepte\n",yytext);colonne = colonne+yyleng;}}

{saut} {ligne++;colonne=1;}
[ \t] {colonne++;}
[- +  * < > & ! , = ; ( ) : / | ] {colonne = colonne+yyleng; return yytext[0];}
.	{printf("\nErreur lexicale dans la ligne %d la colonne %d\n",ligne,colonne);colonne++;}
%%
int yywrap(){
return 0;
}
