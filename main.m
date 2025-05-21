%这个是用来调参和画图的,将调好的参数记录在params_settings里
% Initialization
clear all
close all
% Fixed seed
rng('default')
addpath(genpath('datasets')); % Add path
addpath(genpath('function'));
addpath(genpath('metrics'));

% Import data set
dataname = 'medical';
avg_cls = 2;% The amount of noise added
[pLabels,data,target] = addnoise(dataname,avg_cls);
ttt = 19;%选择对应的数据集
% 1.mirflickr            % 2.music_emotion        % 3.music_style         % 4.YeastBP 
% 5.emotions(3,4,5)      % 6.birds(3,4,5)         % 7.flags(4,5,6)        % 8.foodtruck(5,7,9)
% 9.image(2,3,4)         % 10.scene(3,4,5)        % 11.health(5,7,9)      % 12.recreation(7,9,11)
% 13.science(5,7,9)      % 14.eduction(5,7,9)     % 15.arts(5,7,9,11)     % 16.yeast(5,7,9,11)
% 17.reference(5,7,9,11) % 18.medical(3,5,7,9)    % 19.corel5k(5,7,9,11)  % 20.enron(3,5,7,9)
%%
par = params_settings(ttt);
lambda1s = par(1);
lambda2s = par(2);
lambda3s = par(3);
lambda4s = par(4);
lambda5s = par(5);
ks = par(6);

%%
% lambda1s = [0.0001 0.001 0.01 0.1 1];                  
% lambda2s = [0.0001 0.001 0.01 0.1 1];                     
% lambda3s = [0.001 0.01 0.1 1 10 100]; 
% lambda4s = [0.001 0.01 0.1 1];
% lambda5s = [0.001 0.01 0.1 10 100];
% ks  = [0.2 0.4 0.6 0.8 1];
%%
% lambda1s = [0.1];
% lambda2s = [0.01];                     
% lambda3s = [0.001];
% lambda4s = [0.1];
% lambda5s = [0.1];
% ks = [0.8];
%%
huatu = 0;%是否画损失函数收敛图
oral = length(lambda1s)*length(lambda2s)*length(lambda3s)*length(lambda4s)*length(lambda5s)*length(ks);
onet = 1;
opt.max_iter = 21;
max_AP = 0;
[N,~] = size(data);
indices = crossvalind('Kfold', 1:N ,10);  % Dividing the data set
for t1=1:length(lambda1s)
    for t2=1:length(lambda2s)
        for t3=1:length(lambda3s)
            for t4=1:length(lambda4s)
                for t5=1:length(lambda5s)
                     for t7=1:length(ks)
                         opt.lambda1 = lambda1s(t1);
                         opt.lambda2 = lambda2s(t2);
                         opt.lambda3 = lambda3s(t3);
                         opt.lambda4 = lambda4s(t4);
                         opt.lambda5 = lambda5s(t5);
                         opt.k = ks(t7);

                        disp('start')
                        fprintf('process:%.1f/%.1f\n',onet,oral);
                        onet = onet + 1;
                        disp('loading:');

                        for round = 1:10
                            ht = round*10;
                            fprintf('%.1f%%\n',ht)
                            test_idxs = (indices == round);                       
                            train_idxs = ~test_idxs;                       
                            train_data = data(train_idxs,:);                                           
                            train_target = pLabels(train_idxs,:);                                          
                            % true_target = target(train_idxs,:);                                          
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
                        fprintf('%s,avg_cls=%.1f,λ1=%.5f,λ2=%.5f,λ3=%.5f,,λ4=%.5f,λ5=%.5f,k=%.1f\n HammingLoss=%.3f±%.3f\n RankingLoss=%.3f±%.3f\n OneError=%.3f±%.3f\n Coverage=%.3f±%.3f\n AveragePrecision=%.3f±%.3f\n', ...
                            dataname,avg_cls,opt.lambda1,opt.lambda2,opt.lambda3,opt.lambda4,opt.lambda5,opt.k,mean(HammingLoss),std(HammingLoss),mean(RankingLoss),std(RankingLoss),mean(OneError),std(OneError),mean(Coverage),std(Coverage),mean(AveragePrecision),std(AveragePrecision));
                        fprintf('oral_time=%.2f秒\n',sum(time));         
                        %%
                        AP = mean(AveragePrecision);
                        if AP > max_AP
                            max_AP = AP;
                            max_l1 = opt.lambda1;
                            max_l2 = opt.lambda2;
                            max_l3 = opt.lambda3;
                            max_l4 = opt.lambda4;
                            max_l5 = opt.lambda5;
                            max_k = opt.k;  
                        end
                    
                    %%
                        if huatu == 1
                            step_loss = length(model.loss);
                            figure
                            plot(1:step_loss,model.loss);
                        end 
                        loss = model.loss;
                        filename = strcat(dataname,'_',num2str(avg_cls));
                        save(filename,"loss");

                    end
                end
            end
        end
    end 
end
fprintf('max_l1=%.5f, max_l2=%.5f, max_l3=%.5f, max_l4=%.5f, max_l5=%.5f,max_k=%.2f, max_AP=%.3f\n'...
                                ,max_l1,max_l2,max_l3,max_l4,max_l5,max_k,max_AP);



    




