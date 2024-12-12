% fonction maximisation_classification_SVM_noyau (pour l'exercice 2)

function [pourcentage_meilleur_classification_SVM_test, sigma_opt_test, ...
          vecteur_pourcentages_bonnes_classifications_SVM_app, ...
          vecteur_pourcentages_bonnes_classifications_SVM_test] = ...
          maximisation_classification_SVM_noyau(X_app,Y_app,X_test,Y_test,vecteur_sigma)
    
    N_sig = length(vecteur_sigma);
    max = 0;
    sigma_opt_test=0;
    vecteur_pourcentages_bonnes_classifications_SVM_test = zeros(N_sig,1);
    vecteur_pourcentages_bonnes_classifications_SVM_app = zeros(N_sig,1);

    for i = 1:N_sig
        %création des variables nécessaires
        sigma = vecteur_sigma(i);
        [X_VS,Y_VS,Alpha_VS,c,~]= estim_param_SVM_noyau(X_app,Y_app,sigma);
        
        %prédiction et vérification sur la batterie d'apprentissage
        Y_pred = classification_SVM_avec_noyau(X_app,sigma,X_VS,Y_VS,Alpha_VS,c);
        pourcent_app = length(Y_pred (Y_pred == Y_app ))/ length(Y_pred) *100;
        vecteur_pourcentages_bonnes_classifications_SVM_app(i) = pourcent_app;

        %prédiction et vérification sur la batterie de test
        Y_pred = classification_SVM_avec_noyau(X_test,sigma,X_VS,Y_VS,Alpha_VS,c);
        pourcent_test = length(Y_pred (Y_pred == Y_test ))/ length(Y_pred) *100;
        vecteur_pourcentages_bonnes_classifications_SVM_test(i) = pourcent_test;
        
        %maximisation sur le test
        if pourcent_test > max
            max = pourcent_test;
            sigma_opt_test = sigma;
        
        end

    end


end