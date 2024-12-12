% fonction estim_param_SVM_dual (pour l'exercice 1)

function [X_VS,w,c,code_retour] = estim_param_SVM_dual(X,Y)
    Yd = diag(Y);
    H = Yd*(X*X')*Yd;
    N = length(X);
    f = -ones(1,N);
    lb = zeros(N,1);
    [alpha,~,code_retour,~] = quadprog(H,f,[],[],Y',0,lb,[]);
    
    X_VS =X(alpha > 10^(-6),:) ;
    Y_VS = Y(alpha > 10^(-6),:);

    w = zeros(2,1);
        for i = 1:N
        w = w+ alpha(i)*Y(i).*X(i,:)';
        end
    c = w'*X_VS(1,:)' - Y_VS(1,:)';
    
end
