% fonction classification_SVM (pour l'exercice 1)

function Y_pred = classification_SVM(X,w,c)
    N = length(X);
    Y_pred = zeros(N,1);

    for i = 1:N
        Y_pred(i) = sign(w'*X(i,:)' - c);
    end

end