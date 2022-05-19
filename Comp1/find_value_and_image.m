function [eigenfaces,eigenfaces_value, mu]=find_value_and_image(X)


mu = mean(X,2);
M = size(X,2);
coff=1/sqrt(M)
T = [];
for i=1 : M
    x = (coff*(double(X(:,i)) - mu));
    T= [T x];
end 


R=T.' * T
[eigenvector, eigenvalue]=eig(R)

eigenfaces_value=[]
T_eigenvector = [];

eigenvalue1=diag(eigenvalue)
deneminator=sum(eigenvalue1)
[eigenvalueSort, I]=sort(eigenvalue1, 'descend')
a=0
i=1

while a/deneminator<0.9
a=a+eigenvalueSort(i)
eigenfaces_value=[eigenfaces_value, eigenvalueSort(i) ]
T_eigenvector= [T_eigenvector eigenvector(:,I(i))];
i=i+1
end


eigenfaces =T * T_eigenvector;




end