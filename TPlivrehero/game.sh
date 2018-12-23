#!/bin/bash
clear
rm $1/inventaire/epee 2>/dev/null
CURRENT_PAGE=$1/page1.txt
cat $CURRENT_PAGE

# CURRENT_PAGE contient le chemin du fichier courant
# PAGE_CONTENT contient le texte contenu dans la fichier courant
while true
do
    POTENTIAL_NEXTPAGE=`cat $CURRENT_PAGE | sed 's/[^0-9]*//g'` #Recherche des differentes possibilitée a partir de la page actuel.

    echo "______________________________________________"
    read -p "Saisissez votre reponse: " RESPONSE #saisie de la demande pour la page suivante

    clear

    #On verifie si l'accés à la page demandé est autorisé
    if grep -sq $RESPONSE <<< "$POTENTIAL_NEXTPAGE"
    then
        CURRENT_PAGE=$1/page$RESPONSE.txt # Mise a jours
        cat $CURRENT_PAGE
    else
        echo "Tu n'a pas l'accés à cette page , choisit parmis $POTENTIAL_NEXTPAGE"
        cat $CURRENT_PAGE #re-affiche l'ancien CURRENT_PAGE qui n'a pas été mis a jours
    fi

    # Fermer le programme si le fichier courant contient Mort Ou Bravo
    if  grep -q Bravo $CURRENT_PAGE || grep -q Mort $CURRENT_PAGE
    then
        exit
    fi

    #Ajout d'une épée à l'inventaire si le fichier contient +épée
    if  grep -q +épée $CURRENT_PAGE
    then
        touch $1/inventaire/epee
    fi

    #COMBAT
    if  grep -q "ce battre" $CURRENT_PAGE
    then
        echo "Vous etes en train de vous battre..."
        sleep 2

        # Verification de la presence d'une épée dans l'inventaire
        if [ -f $1/inventaire/epee ]
        then
            echo "Bravo, Vous venez de gagné contre le troll grace à votre épée"
            exit
        else
            echo "Vous avez perdu, contre un troll des caverne à main nue vous n'aviez aucune chance essayez de trouver de quoi vous battre avant le combat"
            exit
        fi
    fi
done
