function [bool] = possedechaine(Graph, chaine)
    bool = 1;
    for i = 1:length(chaine)-1
        if Graph(chaine(i), chaine(i+1)) == 0
            bool = 0;
            return;
        end
    end

end