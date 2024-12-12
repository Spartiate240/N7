% fonction calcul_bon_partitionnement (pour l'exercice 1)

function meilleur_pourcentage_partitionnement = calcul_bon_partitionnement(Y_pred,Y)
    permut = perms(1:3);
    meilleur_pourcentage_partitionnement = 0;
    
    for i = 1:size(permut,1)
        n = 0;
        %changer les classes en fonction de la permutation dans un vecteur
        %temporaire
        B = permut(i,:);
        Y_pred_temp =  zeros(length(Y),2);
        for j = 1:length(Y)
            if Y_pred(j) == 1
                Y_pred_temp(j) = B(1);
            
            elseif Y_pred(j) == 2
                Y_pred_temp(j) = B(2);
            
            elseif Y_pred(j) == 3
                Y_pred_temp(j) = B(3);
            end
        end
    
        %déterminer le nombre d'éléments bien placés
        for j = 1:length(Y)
            if Y(j) == Y_pred_temp(j)
                n = n+1;
            end
        end
        %calcul du pourcentage
        pourcent = n/length(Y)*100;

        %détermination du max
        if pourcent > meilleur_pourcentage_partitionnement
            meilleur_pourcentage_partitionnement = pourcent;
        end
    end
end