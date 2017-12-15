function [seam, total_cost] = vertical_seam(im, E)
    [rows, cols, ~] = size(im);

    % create 2d array of subproblems
    % (lowest-cost vertical seam if the seam ends at pixel i,j)
    M = zeros(size(E));
    M(1, :) = E(1, :);
    for i = 2:rows
        for j = 1:cols  
            center = M(i-1, j);
            if j == 1
                left = inf;
                right = M(i-1, j+1);
            elseif j == cols
                left = M(i-1, j-1);
                right = inf;
            else
                left = M(i-1, j-1);
                right = M(i-1, j+1);
            end

            minVal = min(min(left, right), center);

            M(i, j) = E(i, j) + minVal;
        end
    end

    %find starting point (min energy in last row)
    [val, idx] = min(M(end, 2:cols-1));

    %backtrack upward to find best vertical seam
    seam = false(rows,cols);
    seam(rows,idx) = true; 
    total_cost = val;
    for i = rows-1:-1:1
        left = inf;
        if idx ~= 1
            left = M(i, idx-1);
        end
        
        center = M(i, idx);
        
        right = inf;
        if idx ~= cols
            right = M(i, idx+1);
        end
        

        [val, j] = min(cat(3, left, center, right));
        %total_cost = total_cost + val;
        seam(i,idx+j-2) = true;
        idx = idx+j-2;
    end
    
    figure(5), imagesc(M), colormap jet;
end