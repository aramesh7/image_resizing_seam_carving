function [seam, total_cost] = horizontal_seam(im, E)
    [rows, cols, ~] = size(im);
    
    % create 2d array of subproblems
    % (lowest-cost vertical seam if the seam ends at pixel i,j)
    M = zeros(size(E));
    M(:,1) = E(:,1);
    for j = 2:cols
        for i = 1:rows
            center = M(i, j-1);
            if i == 1
                up = inf;
                down = M(i+1, j-1);
            elseif i == rows
                up = M(i-1, j-1);
                down = inf;
            else
                up = M(i-1, j-1);
                down = M(i+1, j-1);
            end
            
            minVal = min(min(up, down), center);

            M(i, j) = E(i, j) + minVal;
        end
    end

    %find starting point (min energy in last col)
    [val, idx] = min(M(2:rows-1, end));

    %backtrack leftward to find best horizontal seam
    seam = false(rows,cols);
    seam(idx,cols) = true; 
    total_cost = val;
    for j = cols-1:-1:1
        up = inf;
        if idx ~= 1
            up = M(idx-1, j);
        end
        
        center = M(idx, j);
        
        down = inf;
        if idx ~= rows
            down = M(idx+1, j);
        end

        [val, i] = min(cat(3, up, center, down));
        %total_cost = total_cost + val;
        seam(idx+i-2,j) = true;
        idx = idx+i-2;
    end
    
    figure(6), imagesc(M), colormap jet;
end