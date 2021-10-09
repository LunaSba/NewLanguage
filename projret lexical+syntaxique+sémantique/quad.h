#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/types.h>


typedef struct { char op[60];
                 char op1[60];
				 char op2[60];
				 char  resultat[60];
				 //char type[60];
                        } quad;

typedef struct element  {
                int inf;
				struct element *svt;}pile;
typedef struct { char name[60];
                 char op1[60];
				 char op2[60];
                        } tem;
char sauv_deb[600];
quad tabquad[1000];
int qc=0,i=0,j, qt=0;
tem tabtem[9999];
char sw[60];
int sauv_bz,sauv_fin,suivt,sauv_val;
int sauv_br,s_db;
char t[60];
pile *pile_bz,*pile_br,*pile_deb;
int sau_br;

typedef struct{
                       char name[20];

                      }symb;

symb tabtemp[9999];
int indicet=0;

void initpile (pile ** sommet)
{*sommet=NULL;}

int pilevide( pile * sommet)
{if(sommet=NULL) return 1; else return 0;}

int sommetpile(pile * sommet)
{ return sommet->inf;}

void empiler(pile **sommet, int x )

{pile *p;
p=(pile*)malloc(sizeof(pile));
p->inf=x;
p->svt=*sommet;
*sommet=p;
}


void depiler(pile **sommet, int * x )

{pile *p;
p=*sommet;
*sommet=p->svt;
* x=p->inf;
free(p);
}


pile *s=NULL;



void ajoutTemp(char* nom)
{

strcpy(tabtemp[indicet].name,nom);

indicet++;
}

void ajoutquad(char* c1,char* c2,char* c3,char* c4)
{
strcpy(tabquad[qc].op,c1);  //on a un vercteur de type enregistremet qui contient tt les quadrulets avc leurs infos
strcpy(tabquad[qc].op1,c2);
strcpy(tabquad[qc].op2,c3);
strcpy(tabquad[qc].resultat,c4);
qc++;
}

void ajout(char* c1,char* c2,char* c3)
{
strcpy(tabtem[qt].name,c1);
strcpy(tabtem[qt].op1,c2);
strcpy(tabtem[qt].op2,c3);

qt++;
}
void routine1_if(char* c1,char* c2,char* c3,char* c4)
{
strcpy(tabquad[qc].op,c1);
strcpy(tabquad[qc].op1,c2);
strcpy(tabquad[qc].op2,c3);
strcpy(tabquad[qc].resultat,c4);
empiler(&s,qc);
qc++;
}
void routine2_if(char* c1,char* c2,char* c3,char* c4)
{
strcpy(tabquad[qc].op,c1);
strcpy(tabquad[qc].op1,c2);
strcpy(tabquad[qc].op2,c3);
strcpy(tabquad[qc].resultat,c4);
sauv_br=qc;
qc++;depiler(&s,&sauv_bz);
sprintf(t,"%d",qc);
strcpy(tabquad[sauv_bz].op1,t);
}

void routine3_if()
{

sprintf(t,"%d",qc);
strcpy(tabquad[sauv_br].op1,t);
}

void routine4_if()
{
depiler(&s,&sauv_bz);
sprintf(t,"%d",qc);
strcpy(tabquad[sauv_bz].op1,t);
}



void affichquad()
{
puts(""); puts("");
printf("--------------------------------------------\n");
puts("LA TABLE DES QUADRUPLETS :");
printf("------------------------\n");
int i=0;
while(i<qc){ printf("%d-",i); printf("\t( %s , %s , %s , %s )  \n",tabquad[i].op,tabquad[i].op1,tabquad[i].op2,tabquad[i].resultat); i++; }
printf("--------------------------------------------\n");
}
void routine1_For()
{
 /* pour la position du debut */
    empiler(&pile_deb,qc); // on a empiler la position de debut bz
}

void routine2_For(char* c1,char* c2,char* c3,char* c4)
{
   strcpy(tabquad[qc].op,c1); //  ckoi la condition contraire
   strcpy(tabquad[qc].op1,c2); // sa position
   strcpy(tabquad[qc].op2,c3); // la variable
   strcpy(tabquad[qc].resultat,c4); // la variable
   sauv_bz = qc ; // on position la fin de la condition
   empiler(&pile_bz,qc);
   empiler(&s,qc);
   qc++;

   depiler(&pile_bz,&sauv_bz);
   sprintf(t,"%d",qc);
   strcpy(tabquad[sauv_bz].op1,t);
}

void routine3_For(char* c1,char* c2,char* c3,char* c4)
{
   depiler(&pile_deb,&s_db); //on depile le debut pou mettre à jour le bz
   sprintf(sauv_deb,"%d",s_db);
   strcpy(tabquad[qc].op,c1); //  ckoi la condition contraire
   strcpy(tabquad[qc].op1,sauv_deb); // sa position
   strcpy(tabquad[qc].op2,c3); // la variable
   strcpy(tabquad[qc].resultat,c4);
   sauv_br=qc;
qc++;depiler(&s,&sauv_bz);
   empiler(&s,qc);
   sprintf(t,"%d",qc);
   strcpy(tabquad[sauv_bz].op1,t);
}







