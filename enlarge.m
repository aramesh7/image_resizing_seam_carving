%k is how much to enlarge
%type is enlargement direction
function out = enlarge(im, k, type)
    [w,h,~] = size(im);
    if strcmp(type,'width')%vertical seam
        %put k best seams into index map
        seams = cell(k,1);
        
        iter = im;
        for ii = 1:k
            seam = vertical_seam(iter, energy(iter,'gradient'));
            
            %[~,cols] = find(seam==1);
            %for i = 1:w
                %iter(i,cols(i),:) = cat(3,uint8(255),uint8(0),uint8(0));
            %end
            iter = cut(iter, seam, 'vertical');
            seams{ii} = seam;
        end
      
        iter = im;
        for ii = 1:k
            %append col of zeros
            hold = iter;
            iter = uint8([]);
            iter(:,:,1) = cat(2, hold(:,:,1), zeros(size(hold(:,:,1),1),1));
            iter(:,:,2) = cat(2, hold(:,:,2), zeros(size(hold(:,:,2),1),1));
            iter(:,:,3) = cat(2, hold(:,:,3), zeros(size(hold(:,:,3),1),1));
            
            seam = seams{ii};
            imshow(hold)
            [rows,cols] = find(seam);
            for i = 1:w
                %r = (iter(rows(i),cols(i)-1,1)+iter(rows(i),cols(i)+1,1))/2;
                %g = (iter(rows(i),cols(i)-1,2)+iter(rows(i),cols(i)+1,2))/2;
                %b = (iter(rows(i),cols(i)-1,3)+iter(rows(i),cols(i)+1,3))/2;
                iter(rows(i),cols(i)+2:end,:) = iter(rows(i),cols(i)+1:end-1,:);
                %duplicate by copying pixel
                %avging by neighbors doesn't work?
                %iter(i,cols(i)+1,:) = iter(i,cols(i),:);
                iter(rows(i),cols(i)+1,1) = iter(rows(i),cols(i),1);
                iter(rows(i),cols(i)+1,2) = iter(rows(i),cols(i),2);
                iter(rows(i),cols(i)+1,3) = iter(rows(i),cols(i),3);
            end
            
            
        end
        out = iter;
    elseif strcmp(type,'height')%horzontal seam
        %put k best seams into index map
        seams = cell(k,1);
        
        iter = im;
        for ii = 1:k
            seam = horizontal_seam(iter, energy(iter,'gradient'));
            
            %[~,cols] = find(seam==1);
            %for i = 1:w
                %iter(i,cols(i),:) = cat(3,uint8(255),uint8(0),uint8(0));
            %end
            iter = cut(iter, seam, 'horizontal');
            seams{ii} = seam;
        end
      
        iter = im;
        for ii = 1:k
            %append col of zeros
            hold = iter;
            iter = uint8([]);
            iter(:,:,1) = [hold(:,:,1); zeros(1,size(hold(:,:,1),2))];
            iter(:,:,2) = [hold(:,:,2); zeros(1,size(hold(:,:,2),2))];
            iter(:,:,3) = [hold(:,:,3); zeros(1,size(hold(:,:,3),2))];
            
            seam = seams{ii};
            imshow(hold)
            [rows,cols] = find(seam);
            for i = 1:h
                %r = (iter(rows(i),cols(i)-1,1)+iter(rows(i),cols(i)+1,1))/2;
                %g = (iter(rows(i),cols(i)-1,2)+iter(rows(i),cols(i)+1,2))/2;
                %b = (iter(rows(i),cols(i)-1,3)+iter(rows(i),cols(i)+1,3))/2;
                iter(rows(i)+2:end,cols(i),:) = iter(rows(i)+1:end-1,cols(i),:);
                %duplicate by copying pixel
                %avging by neighbors doesn't work?
                %iter(i,cols(i)+1,:) = iter(i,cols(i),:);
                iter(rows(i)+1,cols(i),1) = iter(rows(i),cols(i),1);
                iter(rows(i)+1,cols(i),2) = iter(rows(i),cols(i),2);
                iter(rows(i)+1,cols(i),3) = iter(rows(i),cols(i),3);
            end
            
            
        end
        out = iter;
    end
end