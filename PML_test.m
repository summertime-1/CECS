function [HammingLoss,RankingLoss,OneError,Coverage,AveragePrecision,MicroF1] = PML_test(test_data,test_target,model)
[num_test,~]=size(test_data);
[~,num_class]=size(test_target);

W = model.W;
% Xt = [test_data, ones(num_test,1)];
% Outputs = Xt*W;
Xt = [test_data, ones(num_test,1)];
Xt = Xt';
Outputs = W*Xt;
Outputs = Outputs';
[Outputs,~] = mapminmax(Outputs,0,1);
Pre_Labels = zeros(num_test,num_class);
threshold = 0.99;%%阈值
for i=1:num_test
    for k=1:num_class
        if(Outputs(i,k)>=threshold)
            Pre_Labels(i,k) = 1;
        else
            Pre_Labels(i,k) = 0;
        end
    end
end
Y = test_target;
Y(Y==-1) = 0;
HammingLoss=Hamming_loss(Pre_Labels,Y);
RankingLoss=Ranking_loss(Outputs',test_target');
OneError=One_error(Outputs',test_target');
Coverage=coverage(Outputs',test_target');
AveragePrecision=Average_precision(Outputs',test_target');
MicroF1 = Micro_F1(Pre_Labels',Y');

end

