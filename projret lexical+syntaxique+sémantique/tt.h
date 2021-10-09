#include<stdio.h>
#include<stdlib.h>
#include<string.h>

typedef struct Element {
                        char *Nom;
                        int type; //0 Uint 1 Ufloat
                        int nature; //0 constante 1 variable
                        struct Element *suivant;
                       }Element;

/* Alloue espace pour un noeud */
Element  *creerNoeud()
{
    Element  *p= (Element *) malloc(sizeof(Element)) ;
    p->Nom = (char *) malloc(sizeof(char));
    if (p == NULL)
    {
       printf("erreur le stockage insuffisant\n") ;
       exit(EXIT_FAILURE);
    }
    return p;
}

/* ajoute  un élément  en tete de liste */
Element  *ajoutTete(Element *tete,char *n, int t,int na)
{
    Element *p = creerNoeud();
    p->Nom = n;
    p->type= t;
    p->nature= na;
    p->suivant = tete;
    return p;
}

/* ajoute d’un élément  après une adresse donnée */

Element    *ajoutApres(Element *prd,char *n, int t,int na)
{
    Element *p = creerNoeud();
    p->Nom = n;
    p->type = t;
    p->nature= na;
    p->suivant = prd->suivant;
    prd->suivant = p;
    return p;
}

/* Fonction qui cree une liste FiFo */

Element   *inserer (Element *tete,char *idf,int type,int nature) //creerFifo
{
    Element *prd = tete;
    char  *n= (char *) malloc(sizeof(char)) ;

    // on parcour lla liste des elements de la liste pour inserer à la fin
    if(tete == NULL)
    {
        tete = ajoutTete(tete,idf,type,nature);
        return tete;
    }else{
        while(prd->suivant != NULL) prd=prd->suivant;
        tete = ajoutApres(prd,idf,type,nature);
        return tete ;
    }
}


/* Fonction qui affiche les elements d'une liste d'entiers sur la meme ligne */
void    afficher(Element *tete)
{
    Element *p = tete;
    char  *n= (char *) malloc(sizeof(char)) ;
    printf("\n----------------------------------------------\n");
if(tete->suivant==NULL)
        printf("La liste est vide \n");
else
{
    printf("LA TABLE DES SYMBOLES:\n");
    printf("----------------------\n");
    printf("Identificateur      type        nature      \n");
    printf("--------------      ----        ------      \n");
    p=p->suivant;
    while(p != NULL)
    {
          n = p->Nom;
          printf(" %s                   ", n);
          printf(" %d            ",p->type);
          printf(" %d            \n",p->nature);
          p = p->suivant;
     }
}
     printf("--------------------------------------------\n");
}

//fonction qui retourne les infos sur un nom s'il existe sinon elle retourne une simple reponse
int doubleDeclaration(Element *tete,char *idf) // enlever le int reponse
{
    Element *p = tete;
    char *n = (char *) malloc(sizeof(char));

            while((p != NULL)&&(strcmp(p->Nom,idf)!=0))
                 p = (p->suivant);

            if((p==NULL)||(strcmp(p->Nom,idf)!=0))
                    {
                      return 0; // s il nexiste pas 0
                    }

            else if(strcmp(p->Nom,idf)==0)
                     {
                         return 1; // s il existe 1
                     }
}
int ModificationCostante(Element *tete,char *idf,int l,int c)
{
    Element *p = tete;
    if(doubleDeclaration(p,idf)==1)
    {
        while(strcmp(p->Nom,idf)!=0)
        {
           /* printf("\n%s\n%s",p->Nom,idf);*/p=p->suivant;
        }
        if(p->nature == 0)
        {
            printf("\nErreur semantique,Ligne %d Colonne %d la constante %s est inchangable\n",l,c,idf);
            return 0; //erreur
        }
        else {
               // printf("bien %s \n",idf);
                return;
        }
    }else  printf("\nErreur l'identificateur %s n'existe pas\n",idf);
    //n'existe pas
    return 0;
}

char *retournerType(Element *tete,char *idf)
{
    Element *prd = tete;
         //afficher(tete);
         //printf("%s\n",idf);

         while((strcmp(prd->Nom,idf)!=0)&&(prd->suivant != NULL))
         {
             //printf("%s  %d  %d \n",prd->Nom,prd->type,prd->nature);
               prd = prd->suivant;
               //printf("Fin\n");
         }

         if ((strcmp(prd->Nom,idf)==0)&&(prd->type == 1))
            {
                //printf("%s  %d  %d\n",prd->Nom,prd->type,prd->nature);
              return "reel";
            }else {if((strcmp(prd->Nom,idf)==0)&&(prd->type == 0))
            //printf("%s  %d  %d\n",prd->Nom,prd->type,prd->nature);
            return "entier";}
}/*
int main(){
    Element *l= creerNoeud();
    inserer(l,"nom",1,0);// Element *tete,char *idf,int type,int nature
    inserer(l,"x",0,1);
    inserer(l,"n",1,0);
    afficher(l);
    ModificationCostante(l,"n",4,5);
    char *y = retournerType(l,"x");
    printf("%s",y);
    //printf("%s",c);
}*/


