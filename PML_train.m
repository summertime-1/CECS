function model = PML_train(data,train_data,train_target,opt)
%这里是训练过程
warning('off');
rng('default')

lambda1 = opt.lambda1;
lambda2 = opt.lambda2;
lambda3 = opt.lambda3;
lambda4 = opt.lambda4;
lambda5 = opt.lambda5;
N = opt.N;
max_iter = opt.max_iter;

model = [];

[num_train,dim]=size(train_data);
[~,num_label]=size(train_target);

%% Training
% 定义优化参数
X = [train_data, ones(num_train,1)];
X = X';
Y = train_target;
Y = Y';
F = Y;
P = randn(num_train,N);
d = dim + 1;
W = randn(num_label,d);
U = randn(d,N);
V = randn(num_label,N);
H = eye(num_train);
[~,Lk,~,Ls]= knn_S(data, 5);
Q = eye(d);
Lk = 1/2*(Lk'+Lk);
Ls = 1/2*(Ls'+Ls);
[Lr,~] = relate3(F');
Lr = 1/2*(Lr'+Lr);
miniLossMargin = 1e-4;%收敛性判断阈值
%norm2(X*W-Y)^2+lambda3*norm2(X*W-Y)^2 总的损失函数
%% 总损失计算模板 
% F,2范数(等于2范数) norm(A-B,'fro')^2
% 2,1范数 sum(sqrt(sum(A.*A,2)));
% 迹 trace(A'*Ls*A)
% 核范数（低秩） trace(sqrt(A'*A));
% 1范数（稀疏）sum(sum(abs(A)));
%loss(1) = norm(X*W-Y,'fro')^2+lambda3*norm(W,'fro')^2;
tic;%开始计算时间
%norm2(W*X-F)^2+a*norm2(X*P-U)^2+a*norm2(Y*P-V)^2+b*tr(P'*Ls*P)+c*norm2(W*U-V)^2+e*norm2(W)^2+
for ii = 1:max_iter
    %这里是优化过程
    %% update W
    % Q = diag(1 ./(2 * vecnorm(W)+tinyeps));
    W = (F*(X') + lambda3*V*(U'))*pinv(X*(X') + lambda3*U*(U') +lambda5*Q);
    % Q = compute_Q(W);
    

    %% update P

    P = pinv(lambda1*(X')*X + lambda1*(F')*F + lambda2*Ls)*(lambda1*(X'*U) + lambda1*(F'*V));

    %% update U

    U = pinv(lambda3*(W'*W) + lambda1*eye(dim+1))*(lambda3*(W'*V) + lambda1*X*P);
    % U(U<-1) = -1;
    % U(U>1) = 1;
    [S1,~,S2] = svd(U,"econ");
    U = S1*S2';
    clear S1 S2 

    [Lr,~] = relate3(U);

    %% update V
    V = (lambda1*F*P + lambda3*W*U)*pinv(lambda4*Lr + (lambda1+lambda3)*eye(N));
    % V(V<0) = 0;
    % V(V>1) = 1;
    [S1,~,S2] = svd(V,"econ");
    V = S1*S2';
    clear S1 S2

     %% update H   
    [S1,~,S2] = svd(F'*Y,"econ");
    H = S2*S1';
    % H = eye(num_train);
    clear S1 S2

      % update F
    F = (W*X + Y*H + lambda1*V*P')*pinv((1+1)*eye(num_train) + lambda1*P*P' + lambda4*Lk);
    F(F<0) = 0;
    F(F>Y) = Y(F>Y);


    %%这里是计算每一次的损失，并判断收敛
    loss(ii) = norm(W*X-F,'fro')^2+norm(F-Y*H,'fro')^2+lambda1*(norm(X*P-U,'fro')^2+norm(F*P-V,'fro')^2)+lambda2*trace(P'*Ls*P)+lambda3*norm(W*U-V, 'fro')^2+lambda4*(trace(F*Lk*F')+trace(V*Lr*V'))+lambda5*norm(W,'fro')^2;

    % loss(ii+1) = norm(W*X-F,'fro')^2+norm(F-Y*H,'fro')^2+lambda1*(norm(X*P-U,'fro')^2+norm(F*P-V,'fro')^2)+lambda2*trace(P'*Ls*P)+lambda3*norm(W*U-V, 'fro')^2+lambda4*(trace(F*Lk*F')+trace(V'*Lr*V))+lambda5*norm(W,'fro')^2;
    
    if ii>5
        temp_loss = (loss(ii-1) - loss(ii))/loss(ii-1); 
        if temp_loss<miniLossMargin
            % break;%如果收敛就跳出循环
        end
    end
    time = toc;%得到运行时间
    

end
model.W = W;
model.F = F';
model.P = P;
model.U = U;
model.V = V;
model.Q = Q;
model.time = time;
model.loss = loss;
end



