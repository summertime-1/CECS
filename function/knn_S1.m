function [L]= knn_S(train_data, k)
%knn_S 用来计算局部相似度的拉普拉斯矩阵
%   此处显示详细说明

[num_train, ~]=size(train_data);
distance = EuDist2(train_data,train_data,1);
[near_sample , ind] = sort(distance,2);
ind = ind(:,2:k+1);
segma = sum(near_sample(:,2))/num_train;
P = exp(-distance/(2*segma^2));

R = eye(num_train);
for i=1:num_train
    for j = 1:k
        R(i,ind(i,j)) = P(i,ind(i,j));
    end
end
R = 1/2*(R'+R);
D = diag(sum(R,2));
L = D-R ;
end
