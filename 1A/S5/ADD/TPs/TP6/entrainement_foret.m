% fonction entrainement_foret (pour l'exercice 2)

function foret = entrainement_foret(X,Y,nb_arbres,proportion_individus)
    tirages = randperm(nb_arbres)/nb_arbres *proportion_individus;

    foret = cell(nb_arbres,1);
    [~, b] = size(X);
    nb_var = round(sqrt(b));

    for i = 1:nb_arbres
        qtt = tirages(i);
        
        X_temp = X(qtt);
        Y_temp = Y(qtt);
        foret{i} = fitctree(X,Y,'NumVariablesToSample',nb_var);
        
    end

end
