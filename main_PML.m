function [result] = main_PML(dataname,avg_cls,ttt)
%这里是数据预处理和配置函数
% Initialization
% Fixed seed
rng('default')
addpath(genpath('datasets')); % Add path
addpath(genpath('function'));
addpath(genpath('metrics'));

% Import data set
[pLabels,data,target] = addnoise(dataname,avg_cls);
%%
par = params_settings(ttt);
opt.lambda1 = par(1);
opt.lambda2 = par(2);
opt.lambda3 = par(3);
opt.lambda4 = par(4);
opt.lambda5 = par(5);
opt.k = par(6);
opt.max_iter = 20;
%%
[N,~] = size(data);
indices = crossvalind('Kfold', 1:N ,10);  % Dividing the data set
result = {};
%%十折交叉验证
for round = 1:10
    ht = round*10;
    fprintf('%.1f%%\n',ht)
    test_idxs = (indices == round);                       
    train_idxs = ~test_idxs;                       
    train_data = data(train_idxs,:);                                           
    train_target = pLabels(train_idxs,:);                                                                                    
    test_data = data(test_idxs,:);                                          
    test_target = target(test_idxs,:);
                    
                      
    % pre-processing 归一化                                       
    [train_data, settings]=mapminmax(train_data');                                        
    test_data=mapminmax('apply',test_data',settings);                                          
    train_data(isnan(train_data))=0;                                           
    test_data(isnan(test_data))=0;                                           
    train_data=train_data';                                           
    test_data=test_data';                                             
    X = train_data;
    Xt = test_data;
    Y = train_target;
    Yt = test_target;
    
    [num,~] = size(X);
    % High dimensional kernel mapping   
    [K,Kt] = Kernel_mapping(X',Xt');                       
    K = K';   
    Xt = Kt';
    opt.N = ceil(opt.k*num);

    %training
    model = PML_train(X,K,Y,opt);
    time(round) = model.time;
    % %testing
    [HammingLoss(round),RankingLoss(round),OneError(round),Coverage(round),AveragePrecision(round),~] = PML_test(Xt,Yt,model);
end
fprintf('avg_cls=%.1f,λ1=%.5f,λ2=%.5f,λ3=%.5f,λ4=%.5f,λ5=%.5f,k=%.1f\n HammingLoss=%.3f±%.3f\n RankingLoss=%.3f±%.3f\n OneError=%.3f±%.3f\n Coverage=%.3f±%.3f\n AveragePrecision=%.3f±%.3f\n', ...
    avg_cls,opt.lambda1,opt.lambda2,opt.lambda3,opt.lambda4,opt.lambda5,opt.k,mean(HammingLoss),std(HammingLoss),mean(RankingLoss),std(RankingLoss),mean(OneError),std(OneError),mean(Coverage),std(Coverage),mean(AveragePrecision),std(AveragePrecision));
fprintf('oral_time=%.2f秒\n',sum(time));
clear X Y Xt Yt K Kt Ls N data target train_data test_data train_target test_target 
filename = strcat('result/',dataname,'_avg_',num2str(avg_cls),'_predict.mat');
save(filename);

result = {HammingLoss,RankingLoss,OneError,Coverage,AveragePrecision};
end