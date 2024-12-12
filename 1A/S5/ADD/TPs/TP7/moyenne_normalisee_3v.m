% fonction moyenne_normalisee_3v (pour l'exercice 1bis)

function x = moyenne_normalisee_3v(I)
    d = min(size(I)/10);
    [l, h] = size(I);
    C = zeros(size(I,1),size(I,2));
    
    %séparation de I en 2 parties, le centre et le pourtour
    i_centre = round(l/2);
    j_centre = round(h/2);

    i_min = i_centre-d;
    j_min = j_centre-d;

    i_max = i_centre+d;
    j_max = j_centre+d;



    C(i_min:i_max,j_min:j_max) = 1;
    P = 1 -C;

    I_c_r = I(find(C));
    I_p_r = I(find(P));

    r_c = mean(I_c_r);
    r_p = mean(I_p_r);
    v_p = r_p - r_c;
    Xv2 = moyenne_normalisee_2v(I);
    x = [Xv2 v_p];



end
