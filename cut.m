%seam is a logical mask of image (same size)
function out = cut(im, seam, type)
    [w,h,~] = size(im);
    out = im;
    if strcmp(type,'vertical')
        %if you see a one, shift all pixels to the right of one to the left
        [~,cols] = find(seam==1);
        
        for i = 1:w
            out(i,cols(i):end-1,:) = out(i,cols(i)+1:end,:);
        end
        out = out(:,1:end-1,:);
    elseif strcmp(type,'horizontal')
        [rows,~] = find(seam==1);
        
        for j = 1:h
            out(rows(j):end-1,j,:) = out(rows(j)+1:end,j,:);
        end
        out = out(1:end-1,:,:);
    end
end