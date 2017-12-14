% new_n is the new number of rows. new_m is the new number of cols.
function out = change_aspect(im, new_n, new_m, energy_type)
    [n, m, ~] = size(im);
    
    r = n - new_n;%# rows to cut
    c = m - new_m;%# cols to cut
    r+1
    c+1
    
    %both dimensions smaller
    if c>0 && r>0
        %optimal seams-order
        T = zeros(r+1,c+1);
        chosen = zeros(r+1,c+1);%0 = left, 1 = top
        T(1,1) = 0; %remove zero seams (r=0,c=0)
        
        last_row = im; %im, the last row in this column
        %last_col_vec = []; %im, the whole last column
        last_col_vec = cell(c,1);
        last_col_vec{1} = im;
        
        for j = 1:c+1
            j
            imagesc(T)
            for i = 1:r+1
                if i==1 && j==1
                    continue %already done
                end
                if i-1 <= 0
                    %no last row. only last column.
                    chosen(i,j) = 0;
                    curr = cell2mat(last_col_vec(i));
                    [vert_seam,cost] = vertical_seam(curr,energy(curr,energy_type));
                    cut_curr = cut(curr, vert_seam, 'vertical');
                    last_row = cut_curr;
                    last_col_vec{i} = cut_curr;
                    T(i,j) = T(i,j-1) + cost;
                    continue
                end
                if j-1 <= 0
                    %no last column. only last row.
                    chosen(i,j) = 1;
                    curr = last_row;
                    [horz_seam,cost] = horizontal_seam(curr,energy(curr,energy_type));
                    cut_curr = cut(curr, horz_seam, 'horizontal');
                    last_row = cut_curr;
                    last_col_vec{i} = cut_curr;
                    T(i,j) = T(i-1,j) + cost;
                    continue
                end
                
                [horz_seam,hcost] = horizontal_seam(last_row,energy(last_row,energy_type));
                cut_horz = cut(last_row, horz_seam, 'horizontal');
                
                [vert_seam,vcost] = vertical_seam(cell2mat(last_col_vec(i)),energy(cell2mat(last_col_vec(i)),energy_type));
                cut_vert = cut(cell2mat(last_col_vec(i)), vert_seam, 'vertical');
                
                if (T(i-1,j) + hcost) < (T(i,j-1)+vcost) 
                    %horizontal seam is better
                    chosen(i,j) = 1;
                    last_row = cut_horz;
                    last_col_vec{i} = cut_horz;
                    T(i,j) = T(i-1,j) + hcost;
                else
                    chosen(i,j) = 0;
                    last_row = cut_vert;
                    last_col_vec{i} = cut_vert;
                    T(i,j) = T(i,j-1) + vcost;
                end
                
                
            end
        end
        
        %figure(2), imagesc(T), colormap jet;
        
        %backtrack through T(r,c) to T(0,0), applying removals.
        reverse_ops = []; %0=vertical,1=horizontal
        curr_row = r+1;
        curr_col = c+1;
        path_mask = false(r+1,c+1);
        for i = 1:r+c
                path_mask(curr_row,curr_col) = true;
                if chosen(curr_row,curr_col) == 1 %top/horizontal
                    reverse_ops = [reverse_ops; 1];
                    curr_row = curr_row - 1;
                else
                    reverse_ops = [reverse_ops; 0];
                    curr_col = curr_col - 1;
                end
                
                
        end
        
        ops = wrev(reverse_ops);
        
        iterate_im = im;
        for i = 1:size(ops)
            if ops(i) == 0 %vertical
                E = energy(iterate_im, energy_type);
                [vert_seam,~] = vertical_seam(iterate_im, E);
                iterate_im = cut(iterate_im, vert_seam, 'vertical');
                imshow(iterate_im)
            else
                E = energy(iterate_im, energy_type);
                [horz_seam,~] = horizontal_seam(iterate_im, E);
                iterate_im = cut(iterate_im, horz_seam, 'horizontal');
                imshow(iterate_im)
            end
                
        end
        
        imshow(imadd(double(path_mask),mat2gray(T)))
        
        out = iterate_im;
    %if only less cols
    elseif c > 0
        iterate_im = im;
        
        for i = 1:c %cut vertical seam c times
            E = energy(iterate_im, energy_type);
            [vert_seam,~] = vertical_seam(iterate_im, E);
            iterate_im = cut(iterate_im, vert_seam, 'vertical');
            imshow(iterate_im)
            %imshow(vert_seam)
            %imshow(mat2gray(E))
        end
        
        out = iterate_im;
    
    %if only less rows
    elseif r > 0
        iterate_im = im;
        
        for i = 1:r %cut horizontal seam r times
            E = energy(iterate_im, energy_type);
            [horz_seam,~] = horizontal_seam(iterate_im, E);
            iterate_im = cut(iterate_im, horz_seam, 'horizontal');
            imshow(iterate_im)
            %imshow(horz_seam)
        end
        
        out = iterate_im;
    end
    
    
end