%k is how much to enlarge
%type is enlargement direction
function out = naive_enlarge(im, k, type)
    [w,h,~] = size(im);
    if strcmp(type,'width')%vertical seam
        iter = im;
        for ii = 1:k
            %append col of zeros
            hold = iter;
            iter = uint8([]);
            iter(:,:,1) = cat(2, hold(:,:,1), zeros(size(hold(:,:,1),1),1));
            iter(:,:,2) = cat(2, hold(:,:,2), zeros(size(hold(:,:,2),1),1));
            iter(:,:,3) = cat(2, hold(:,:,3), zeros(size(hold(:,:,3),1),1));
            
            seam = vertical_seam(iter, energy(iter,'gradient'));
            [~,cols] = find(seam==1);
            for i = 1:w
                iter(i,cols(i)+2:end,:) = iter(i,cols(i)+1:end-1,:);
                %duplicate by copying pixel
                %avging by neighbors doesn't work?
                iter(i,cols(i)+1,:) = iter(i,cols(i),:);
            end
            
            
        end
        out = iter;
    elseif strcmp(type,'height')%horzontal seam
    end
end