function [seam, total_cost] = forward_horizontal_seam(im_input)
    I = rgb2gray(im_input);
    [rows,cols] = size(I);

    C_T = zeros(size(I));
    C_M = zeros(size(I));
    C_B = zeros(size(I));

    for i = 1:rows
        for j =1:cols
            if i==1 && j==1
                C_T(i,j) = abs(I(i+1,j));
                C_M(i,j) =  abs(I(i+1,j));
                C_B(i,j) =  abs(I(i+1,j)) + abs(I(i+1,j)); 
            elseif i==rows && j==1
                C_T(i,j) = abs(I(i-1,j)) + abs(I(i-1,j));
                C_M(i,j) =  abs(I(i-1,j));
                C_B(i,j) =  abs(I(i-1,j));
            elseif j==1
                C_T(i,j) = abs(I(i+1,j) - I(i-1,j)) + abs(I(i-1,j));
                C_M(i,j) =  abs(I(i+1,j) - I(i-1,j));
                C_B(i,j) =  abs(I(i+1,j) - I(i-1,j)) + abs(I(i+1,j));
            elseif i==1
                C_T(i,j) = abs(I(i+1,j)) + abs(I(i,j-1));
                C_M(i,j) =  abs(I(i+1,j));
                C_B(i,j) =  abs(I(i+1,j)) + abs(I(i,j-1) - I(i+1,j));
            elseif i==rows
                C_T(i,j) = abs(I(i-1,j)) + abs(I(i,j-1)-I(i-1,j));
                C_M(i,j) =  abs(I(i-1,j));
                C_B(i,j) =  abs(I(i-1,j)) + abs(I(i,j-1));
            else
                C_T(i,j) = abs(I(i+1,j) - I(i-1,j)) + abs(I(i,j-1)-I(i-1,j));
                C_M(i,j) =  abs(I(i+1,j) - I(i-1,j));
                C_B(i,j) =  abs(I(i+1,j) - I(i-1,j)) + abs(I(i,j-1) - I(i+1,j)); 
            end
            
        end
    end
    
    [rows, cols, ~] = size(I);

    % create 2d array of subproblems
    % (lowest-cost vertical seam if the seam ends at pixel i,j)
    M = zeros(size(I));
    for j = 1:cols    
        for i = 1:rows  
            if j==1
                top = C_T(i,j);
                center = C_M(i,j);
                bottom = C_B(i,j);
            elseif i==1
                top = inf;
                center = M(i,j-1) + C_M(i,j);
                bottom = M(i+1,j-1) + C_B(i,j);
            elseif i==rows
                top = M(i-1,j-1) + C_T(i,j);
                center = M(i,j-1) + C_M(i,j);
                bottom = inf;
            else
                top = M(i-1,j-1) + C_T(i,j);
                center = M(i,j-1) + C_M(i,j);
                bottom = M(i+1,j-1) + C_B(i,j);
            end
            M(i,j) = min(min(top, bottom), center);
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
    
    figure(4), imagesc(M), colormap jet;

end