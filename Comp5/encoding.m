function YB=encoding(DCT, n, m, N, M)
dim=size(DCT);
I_zigzag=cell(dim(1),dim(2));
I_runcode=cell(dim(1),dim(2));
% zig-zag coding of the each 8 X 8 Block.
for a=1:dim(1)
    for b=1:dim(2)
        I_zigzag{a,b}=zeros(1,0);
        freq_sum=2:(N+M);
        counter=1;
        for i=1:length(freq_sum)
            if i<=((length(freq_sum)+1)/2)
                if rem(i,2)~=0
                    x_indices=counter:freq_sum(i)-counter;
                else
                    x_indices=freq_sum(i)-counter:-1:counter;
                end
                    index_len=length(x_indices);
                    y_indices=x_indices(index_len:-1:1); % Creating reverse of the array as "y_indices".
                    for p=1:index_len
                        if DCT{a,b}(x_indices(p),y_indices(p))<0
                            bin_eq=dec2bin(bitxor(2^n-1,ceil(abs(DCT{a,b}(x_indices(p),y_indices(p))))),n);
                        else
                            bin_eq=dec2bin(DCT{a,b}(x_indices(p),y_indices(p)),n);
                        end
                        I_zigzag{a,b}=[I_zigzag{a,b},bin_eq(1:m)];
                    end
            else
                counter=counter+1;
                if rem(i,2)~=0
                    x_indices=counter:freq_sum(i)-counter;
                else
                    x_indices=freq_sum(i)-counter:-1:counter;
                end
                    index_len=length(x_indices);
                    y_indices=x_indices(index_len:-1:1); % Creating reverse of the array as "y_indices".
                    for p=1:index_len
                        if DCT{a,b}(x_indices(p),y_indices(p))<0
                            bin_eq=dec2bin(bitxor(2^n-1,ceil(abs(DCT{a,b}(x_indices(p),y_indices(p))))),n);
                        else
                            bin_eq=dec2bin(DCT{a,b}(x_indices(p),y_indices(p)),n);
                        end
                        I_zigzag{a,b}=[I_zigzag{a,b},bin_eq(1:m)];
                    end
            end
        end
    end
end

% Run-Length Encoding the resulting code.
for a=1:dim(1)
    for b=1:dim(2)
        
        % Computing the Count values for the corresponding symbols and
        % savin them in "I_run" structure.
        count=0;
        run=zeros(1,0);
        sym=I_zigzag{a,b}(1);
        j=1;
        block_len=length(I_zigzag{a,b});
        for i=1:block_len
            if I_zigzag{a,b}(i)==sym
                count=count+1;
            else
                run.count(j)=count;
                run.sym(j)=sym;
                j=j+1;
                sym=I_zigzag{a,b}(i);
                count=1;
            end
            if i==block_len
                run.count(j)=count;
                run.sym(j)=sym;
            end
        end 
        
        % Computing the codelength needed for the count values.
        dimt=length(run.count);  % calculates number of symbols being encoded.
        maxvalue=max(run.count);  % finds the maximum count value in the count array of run structure.
        codelength=log2(maxvalue)+1;
        codelength=floor(codelength);
        
        % Encoding the count values along with their symbols.
        I_runcode{a,b}=zeros(1,0);
        for i=1:dimt
            I_runcode{a,b}=[I_runcode{a,b},dec2bin(run.count(i),codelength),run.sym(i)];
        end
    end
end

YB=I_runcode;
end