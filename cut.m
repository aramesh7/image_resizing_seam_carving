%seam is a logical mask of image (same size)
function out = cut(im, seam, type)
    [w,h,~] = size(im);
    out = im;
    if strcmp(type,'vertical')
        %if you see a one, shift all pixels to the right of one to the left
        [rows,cols] = find(seam==1);
        
        for i = 1:w
            out(rows(i),cols(i):end-1,:) = out(rows(i),cols(i)+1:end,:);
        end
        out = out(:,1:end-1,:);
    elseif strcmp(type,'horizontal')
        [rows,cols] = find(seam==1);
        
        for j = 1:h
            out(rows(j):end-1,cols(j),:) = out(rows(j)+1:end,cols(j),:);
        end
        out = out(1:end-1,:,:);
    end
end