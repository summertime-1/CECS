function [R,L1,P,L2]= knn_S(train_data, k)
%KNN_L 此处显示有关此函数的摘要
%   此处显示详细说明

[num_train, ~]=size(train_data);
distance = EuDist2(train_data,train_data,1);
[near_sample , ind] = sort(distance,2);
ind = ind(:,2:k+1);
segma = sum(near_sample(:,2))/num_train;
P = exp(-distance/(segma^2));

R = eye(num_train);
for i=1:num_train
    for j = 1:k
        R(i,ind(i,j)) = P(i,ind(i,j));
    end
end

SUM = sum(R,2);
D = diag(SUM);
L1 = D-R ;
SUM = sum(P,2);
D = diag(SUM);
L2 = D-P ;
end
