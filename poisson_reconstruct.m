function im_out = toy_reconstruct(Fx,Fy,im)
    s = im;
    [imh, imw, nb] = size(im); 
    im2var = zeros(imh, imw); 
    im2var(1:imh*imw) = 1:imh*imw; 
    
    A = sparse([], [], [], 999999, imh*imw, imh*imw*2);
    b = [];
    
    e = 0;
    
    for y = 1:imh
        for x = 1:imw
            %obj1
            if(x+1<=imw)
                e=e+1;
                A(e, im2var(y,x+1))=1;
                A(e, im2var(y,x))=-1;
                b(e) = Fx(y,x); 
            end
            
            %obj2
            if(y+1<=imh)
                e=e+1;
                A(e, im2var(y+1,x))=1;
                A(e, im2var(y,x))=-1;
                b(e) = Fy(y,x);
            end
        end
    end
    e=e+1;
    A(e, im2var(50,50))=1;
    b(e)=s(50,50);
    
    %cut down A
    [bh,bw] = size(b);
    [ah,aw] = size(A);
    
    A = A(1:bw,1:aw);
    b=transpose(b);
    v = A\b;
    im_out = reshape(v, [imh,imw]);
