function [seam, total_cost] = forward_vertical_seam(im_input)
    I = rgb2gray(im_input);
    [rows,cols] = size(I);

    C_L = zeros(size(I));
    C_U = zeros(size(I));
    C_R = zeros(size(I));

    for i = 1:rows
        for j =1:cols
            if i==1 && j==1
                C_L(i,j) = abs(I(i,j+1));
                C_U(i,j) = abs(I(i,j+1));
                C_R(i,j) = 2*abs(I(i,j+1));
            elseif i==1 && j==cols
                C_L(i,j) =  2*abs(I(i,j-1));
                C_U(i,j) =  abs(I(i,j-1));
                C_R(i,j) =  abs(I(i,j-1));
            elseif i==1
                C_L(i,j) = abs(I(i,j+1) - I(i,j-1)) + abs(I(i,j-1));
                C_U(i,j) =  abs(I(i,j+1) - I(i,j-1));
                C_R(i,j) =  abs(I(i,j+1) - I(i,j-1)) + abs(I(i,j+1)); 
            elseif j==1
                C_L(i,j) = abs(I(i,j+1)) + abs(I(i-1,j));
                C_U(i,j) = abs(I(i,j+1));
                C_R(i,j) = abs(I(i,j+1)) + abs(I(i-1,j) - I(i,j+1));
            elseif j==cols
                C_L(i,j) = abs(I(i,j-1)) + abs(I(i-1,j)-I(i,j-1));
                C_U(i,j) =  abs(I(i,j-1));
                C_R(i,j) =  abs(I(i,j-1)) + abs(I(i-1,j)); 
            else
                C_L(i,j) = abs(I(i,j+1) - I(i,j-1)) + abs(I(i-1,j)-I(i,j-1));
                C_U(i,j) =  abs(I(i,j+1) - I(i,j-1));
                C_R(i,j) =  abs(I(i,j+1) - I(i,j-1)) + abs(I(i-1,j) - I(i,j+1)); 
            end
            
        end
    end
    [rows, cols, ~] = size(I);

    % create 2d array of subproblems
    % (lowest-cost vertical seam if the seam ends at pixel i,j)
    M = zeros(size(I));
    for i = 1:rows
        for j = 1:cols
            if i==1
                left = C_L(i,j);
                center = C_U(i,j);
                right = C_R(i,j);
            elseif j==1
                left = inf;
                center = M(i-1,j) + C_U(i,j);
                right = M(i-1,j+1) + C_R(i,j);
            elseif j==cols
                left = M(i-1,j-1) + C_L(i,j);
                center = M(i-1,j) + C_U(i,j);
                right = inf;
            else
                left = M(i-1,j-1) + C_L(i,j);
                center = M(i-1,j) + C_U(i,j);
                right = M(i-1,j+1) + C_R(i,j);
            end
            M(i,j) = min(min(left, right), center);
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
    
    figure(4), imagesc(M), colormap jet;

end