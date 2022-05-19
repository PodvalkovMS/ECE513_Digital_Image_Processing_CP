D=rand(5,5);
M1=rand(5,5);
M2=rand(5,5);

A=D*(M1+M2)*inv(D)
B=D*M1*inv(D)+D*M2*inv(D)