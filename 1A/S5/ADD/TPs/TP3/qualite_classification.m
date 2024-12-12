% fonction qualite_classification (pour l'exercice 2)

function [pourcentage_bonnes_classifications_total,pourcentage_bonnes_classifications_fibrome, ...
          pourcentage_bonnes_classifications_melanome] = qualite_classification(Y_pred,Y)

    n = length(Y);
    % % classification :
    f = 0; %nbr fibrome bien choisi
    m = 0; %nbr melanome bien choisi

    nbr_f = 0; %nbr de fimbrome dans les trucs
    nbr_m = 0; %nbr de melanome dans les trucs

    for i = 1:n
        if Y(i) * Y_pred(i) == 1
            f = f+1;
        elseif Y(i)*Y_pred(i)==4
            m = m+1;
        end
        if Y(i) == 1
            nbr_f = nbr_f +1;
        else
            nbr_m = nbr_m +1;
    end
    
    pourcentage_bonnes_classifications_fibrome = f/nbr_f *100;
    pourcentage_bonnes_classifications_melanome = m/nbr_m *100;
    pourcentage_bonnes_classifications_total = (f+m)/n *100;



end