%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include"tt.h"
#include "quad.h"
int type_idf;
Element* L;
extern FILE* yyin;
extern int ligne,colonne;
int yyparse();
int yylex();
char *type_compatibilite; 
int yyerror(char *s);
char *reponse;
char *reponse_type;
char temp[60];
char *y;
int q;
char buffer[20];
char c1[20];
char c2[20];
char c3[20];
%}

%union
{
char* chaine;
int entier;
float reel;
struct{ 
        char *val;
        char *type_exp;
		}exp;
struct{ 
        char ty_reel[128];
        char ty_entier[128];
		}val;
}

%token INST DEC FIN define IF ELSE  FOR ENDFOR FINIF Uint Ufloat ',' '=' ';' '(' ')' ':' '+' '-' '*' '/' '<' '>' '&' '|' '!' 
%token <chaine> idf
%token <entier> type_Uint
%token <reel> type_Ufloat
%token <chaine> commentaire
%type <exp> E
%type <exp> O
%type <exp> K
%type <exp> P
%type <exp> valeur
%type <val> nombre
%type <exp> expression
%type <exp> affectationFor
%type <exp> expression_arethmetique
%left '-' '+' 
%left '*' '/'
%left '|'
%left '&'
%left '!'
%left '<' '>' "==" "!=" "<=" ">="
%%

s: com nom_programe com DEC D INST  I FIN {printf("\n ********************************* programme accepte********************************************"); afficher(L);affichquad();YYACCEPT ;};

com : commentaire|
nom_programe : idf														 	

D : G| 
G : declaration_variable G |declaration_constante G | commentaire G | declaration_variable  |  declaration_constante  |  commentaire 
												
declaration_variable : type liste_parametre ';' 

type : Uint {type_idf=0;}
       | Ufloat {type_idf=1;}
	   
liste_parametre : liste_parametre ',' idf  { if(doubleDeclaration(L,$3)==1) {printf("Erreur semantique,Ligne %d Colonne %d l'identificateur %s existe deja\n",ligne,colonne,$3);YYABORT;}
                                             else {inserer(L,$3,type_idf,1);} }
											 
                  | idf                    { if(doubleDeclaration(L,$1)==1) {printf("Erreur semantique,Ligne %d Colonne %d l'identificateur %s existe deja\n",ligne,colonne,$1);YYABORT;}
                                             else {inserer(L,$1,type_idf,1);}}                
                  
declaration_constante : define type liste_parametre_aff ';' 
liste_parametre_aff : idf  '='  nombre     { if(doubleDeclaration(L,$1)==1) {printf("Erreur semantique,Ligne %d Colonne %d l'identificateur %s existe deja\n",ligne,colonne,$1);YYABORT;}
                                            else {if(type_idf==1) y="reel";else y="entier";
											if (strcmp(y,type_compatibilite)!=0){printf("Erreur semantique,Ligne %d Colonne %d Incompatibilite des types \n",ligne,colonne);YYABORT;}
											 else {inserer(L,$1,type_idf,0);
											 if(strcmp($3.ty_reel,"")==0){ajoutquad("=",$3.ty_entier,"",$1);}else{ajoutquad("=",$3.ty_reel,"",$1);}}}}
											 
nombre :  type_Ufloat {type_compatibilite="reel";sprintf($$.ty_reel,"%f", $1);sprintf($$.ty_entier,"%s","");}
          | type_Uint {type_compatibilite="entier";sprintf($$.ty_entier,"%d", $1);sprintf($$.ty_reel,"%s","");}
		  | '(' '-' type_Uint ')' {type_compatibilite="entier";sprintf($$.ty_entier,"%d", $3); strcat(c1,"-");sprintf(c2,"%s", $$.ty_entier);
		  strcat(c1,c2); sprintf($$.ty_entier,"%s", c1); sprintf(c1,"%s", " ");sprintf(c2,"%s", " ");sprintf($$.ty_reel,"%s","");}
          | '(' '-' type_Ufloat ')' {type_compatibilite="reel";sprintf($$.ty_reel,"%f", $3); strcat(c1,"-");sprintf(c2,"%s", $$.ty_reel);
		  strcat(c1,c2); sprintf($$.ty_reel,"%s", c1); sprintf(c1,"%s", " ");sprintf(c2,"%s", " ");sprintf($$.ty_entier,"%s","");}                   


I : N|
N : conditionIF  N | boucle N | affectation N | commentaire N | conditionIF | boucle | affectation | commentaire 

/*instruction : affectation| affectation instruction*/
affectation : idf '=' E ';'  {if(ModificationCostante(L,$1,ligne,colonne)==0) YYABORT;
                              else {reponse_type = retournerType(L,$1); 
		                     if(reponse_type != $3.type_exp) {printf("Erreur semantique,Ligne %d Colonne %d Incompatibilite des types \n",ligne,colonne);YYABORT;}
							 else ajoutquad("=",$3.val,"",$1);}}

expression_arethmetique : E                  {$$.type_exp = $1.type_exp;}      

E: E '+' E   {if($1.type_exp != $3.type_exp) {printf("Erreur semantique,Ligne %d Colonne %d Incompatibilite des types \n",ligne,colonne);YYABORT;} 
                                            else ($$.type_exp = $1.type_exp);sprintf(temp,"t%d",indicet);ajoutTemp(temp);
											ajoutquad("+",$1.val,$3.val,temp);strcpy($$.val,temp);}
  |E '-' E   {if($1.type_exp != $3.type_exp) {printf("Erreur semantique,Ligne %d Colonne %d Incompatibilite des types \n",ligne,colonne);YYABORT;} 
                                            else ($$.type_exp = $1.type_exp);sprintf(temp,"t%d",indicet);ajoutTemp(temp);  
											ajoutquad("-",$1.val,$3.val,temp);strcpy($$.val,temp);}
  |E '/' E   {if($1.type_exp != $3.type_exp) {printf("Erreur semantique,Ligne %d Colonne %d Incompatibilite des types \n",ligne,colonne);YYABORT;} 
                                            else ($$.type_exp = $1.type_exp);sprintf(temp,"t%d",indicet);ajoutTemp(temp); 
											ajoutquad("/",$1.val,$3.val,temp);strcpy($$.val,temp);}
  |E '*' E   {if($1.type_exp != $3.type_exp) {printf("Erreur semantique,Ligne %s Colonne %s Incompatibilite des types \n",ligne,colonne);YYABORT;} 
                                            else ($$.type_exp = $1.type_exp);sprintf(temp,"t%d",indicet);ajoutTemp(temp);  /*on prend l'indice*/
											ajoutquad("*",$1.val,$3.val,temp);strcpy($$.val,temp);}
  |nombre    { $$.type_exp=type_compatibilite;if(strcmp(type_compatibilite,"reel")==0){ sprintf(c3,"%s",$1.ty_reel);$$.val=c3;}else {$$.val = $1.ty_entier;}}
  |idf		 {if(doubleDeclaration(L,$1)==0){printf("Erreur semantique,Ligne %d Colonne %d l'identificateur %s n'existe pas\n",ligne,colonne,$1);YYABORT;}
	          else{reponse =retournerType(L,$1);$$.type_exp = reponse ;strcpy($$.val,$1);}}
  |'(' E ')' {$$.type_exp = $2.type_exp;strcpy($$.val,temp);}           
  
  
separateur : '+'|'-'|'/'|'*'


conditionIF : A   sinon FINIF 
instructionIF: I
sinon : ELSE instructionIF    {routine3_if();}
        |
A :  B  instructionIF       {routine2_if("BR"," "," "," ");};
B :  IF  expression_logique  ':' { q=qt-1;
                               routine1_if(tabtem[q].name," ",tabtem[q].op1,tabtem[q].op2);};
expression_logique : P 
P : O                           {$$.type_exp = $1.type_exp ;}
O : O '|' K     {($$.type_exp = $1.type_exp);}
	
	|O '>' K	{if($1.type_exp != $3.type_exp) {printf("Erreur semantique,Ligne %d Colonne %d Incompatibilite des types \n",ligne,colonne);YYABORT;} 
                 else ($$.type_exp = $1.type_exp);
			    strcpy(tabtem[qt-1].op1,$1.val);strcpy(tabtem[qt-1].op2,$3.val);strcpy(tabtem[qt-1].name,"BLE");}
	
	|O '<' K    {if($1.type_exp != $3.type_exp) {printf("Erreur semantique,Ligne %d Colonne %d Incompatibilite des types \n",ligne,colonne);YYABORT;} 
                 else ($$.type_exp = $1.type_exp);
			    strcpy(tabtem[qt-1].op1,$1.val);strcpy(tabtem[qt-1].op2,$3.val);strcpy(tabtem[qt-1].name,"BGE");}
	
	|O '&' K    {($$.type_exp = $1.type_exp);}
	
	|O '=''>' K {if($1.type_exp != $4.type_exp) {printf("Erreur semantique,Ligne %d Colonne %d Incompatibilite des types \n",ligne,colonne);YYABORT;} 
                 else ($$.type_exp = $1.type_exp);
				 strcpy(tabtem[qt-1].op1,$1.val);strcpy(tabtem[qt-1].op2,$4.val);strcpy(tabtem[qt-1].name,"BL");}
    
	|O '=''<' K {if($1.type_exp != $4.type_exp) {printf("Erreur semantique,Ligne %d Colonne %d Incompatibilite des types \n",ligne,colonne);YYABORT;} 
                 else ($$.type_exp = $1.type_exp);
				 strcpy(tabtem[qt-1].op1,$1.val);strcpy(tabtem[qt-1].op2,$4.val);strcpy(tabtem[qt-1].name,"BG");}
	
	|O '!''=' K {if($1.type_exp != $4.type_exp) {printf("Erreur semantique,Ligne %d Colonne %d Incompatibilite des types \n",ligne,colonne);YYABORT;} 
                 else ($$.type_exp = $1.type_exp);
				 strcpy(tabtem[qt-1].op1,$1.val);strcpy(tabtem[qt-1].op2,$4.val);strcpy(tabtem[qt-1].name,"BE");}
	
	|O '=''=' K {if($1.type_exp != $4.type_exp) {printf("Erreur semantique,Ligne %d Colonne %d Incompatibilite des types \n",ligne,colonne);YYABORT;} 
                 else ($$.type_exp = $1.type_exp);
				 strcpy(tabtem[qt-1].op1,$1.val);strcpy(tabtem[qt-1].op2,$4.val);strcpy(tabtem[qt-1].name,"BNE");}
	
	| K                         {$$.type_exp = $1.type_exp;}
K :  '(' P ')'                  {$$.type_exp = $2.type_exp;/*ajoutquad("BZ"," "," "," ");*/strcpy($$.val,temp);}
    | '!' '(' P ')'             {$$.type_exp = $3.type_exp;/* ajoutquad("BNZ"," "," "," ");*/strcpy($$.val,temp);}
    |valeur                      
	|valeur separateur expression  {if($1.type_exp != $3.type_exp) {printf("Erreur semantique,Ligne %d Colonne %d Incompatibilite des types \n",ligne,colonne);YYABORT;} 
                                else ($$.type_exp = $1.type_exp);}
	
expression :  expression separateur valeur   {if($1.type_exp != $3.type_exp) {printf("Erreur semantique,Ligne %d Colonne %d Incompatibilite des types \n",ligne,colonne);YYABORT;} 
                                              else ($$.type_exp = $1.type_exp);}
			  | '(' expression ')'           {$$.type_exp = $2.type_exp;}
			  | valeur
			  
valeur : idf            {if(doubleDeclaration(L,$1)==0){printf("Erreur semantique,Ligne %d Colonne %d l'identificateur %s n'existe pas\n",ligne,colonne,$1);YYABORT;}
	          else{reponse =retournerType(L,$1);$$.type_exp = reponse ;strcpy($$.val,$1);}}
  |nombre    { $$.type_exp=type_compatibilite;if(strcmp(type_compatibilite,"reel")==0){  $$.val =$1.ty_reel;}else  {$$.val =$1.ty_entier;}}



boucle : W affectationFor ')' instructionFOR ENDFOR routine3 
W : S conditionFOR ';' routine2 
S :  FOR  '('affectation routine1

routine1 : {routine1_For();};
routine2 : {q=qt-1;routine2_For(tabtem[q].name," ",tabtem[q].op1,tabtem[q].op2);qt--;};
routine3 : {routine3_For("BR"," "," "," ");};
conditionFOR : '(' O ')' 

affectationFor : idf '=' expression_arethmetique    {if(ModificationCostante(L,$1,ligne,colonne)==0) YYABORT;
                                                    else {reponse_type = retournerType(L,$1); 
		                                             if(reponse_type != $3.type_exp)
												     {printf("Erreur semantique,Ligne %d Colonne %d Incompatibilite des types \n",ligne,colonne);YYABORT;}
							                          else ajoutquad("=",$3.val,"",$1);}}
instructionFOR : I
; 
%% 
int yyerror(char* msg)
{
printf("%s : Ligne %d Colonne %d ",msg,ligne,colonne);
return 0;
}
int main()
{  
L = creerNoeud();  
yyin=fopen("g.txt","r");  
yyparse();  
return 0;  
}
