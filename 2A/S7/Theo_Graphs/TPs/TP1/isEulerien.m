function [bool] = isEulerien(graph)
    % List of the degrees of each node
    % btw: length(degrees) = number of nodes
    degrees = sum(graph, 2);
    bool = 0;
    nb_imp = 0;
    % On récupère le nombre de noeuds impairs
    for i = 1:length(degrees)
        if mod(degrees(i), 2) ~= 0
            nb_imp = nb_imp + 1;
        end
    end

    if nb_imp == 0 || nb_imp == 2
        bool = 1;
    end
end