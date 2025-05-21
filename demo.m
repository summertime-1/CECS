%%结果会记录在result里
clear
close all
dataname = 'emotions';
avg_cls = 3;% The amount of noise added
ttt = 5;%选择对应数据集的参数
% 1.mirflickr(5.29)      % 2.music_emotion6.04    % 3.music_style(3.35)   % 4.YeastBP(18.84)
% 5.emotions(3,4,5)      % 6.birds(3,4,5)         % 7.flags(4,5,6)        % 8.foodtruck(5,7,9)
% 9.image(2,3,4)         % 10.scene(3,4,5)        % 11.health(5,7,9)      % 12.recreation(7,9,11)
% 13.science(5,7,9)      % 14.eduction(5,7,9)     % 15.arts(5,7,9,11)     % 16.yeast(5,7,9,11)
% 17.reference(5,7,9,11) % 18.medical(3,5,7,9)    % 19.corel5k(5,7,9,11)  % 20.enron(3,5,7,9)
%[~] = main_PML(dataname,avg_cls,ttt);
%%% 可以挂着跑多个数据集.       
%[~] = main_PML(dataname,5,ttt);
%[~] = main_PML(dataname,7,ttt);
%[~] = main_PML(dataname,9,ttt);

%% 1 2 3 4
% [~] = main_PML('mirflickr',5.29,1);
% [~] = main_PML('music_emotion',6.04,2); 
% [~] = main_PML('music_style',3.35,3);
% [~] = main_PML('YeastBP',18.84,4);
%% 5 6
%[~] = main_PML('emotions',3,5);
%[~] = main_PML('emotions',4,6);
 % [~] = main_PML('emotions',5,6);
% % %% 7
%[~] = main_PML('birds',3,7);
[~] = main_PML('birds',4,7);
% [~] = main_PML('birds',5,7);
% %% 10
[~] = main_PML('image',2,10);
% [~] = main_PML('image',3,11);
% [~] = main_PML('image',4,11);
% % %% 12
% [~] = main_PML('scene',3,12);
% [~] = main_PML('scene',4,12);
% [~] = main_PML('scene',5,12);
% %% 13 
% [~] = main_PML('health',5,13);
% [~] = main_PML('health',7,13);
% [~] = main_PML('health',9,13);
% % %% 14
% [~] = main_PML('recreation',7,14);
% [~] = main_PML('recreation',9,14);
% [~] = main_PML('recreation',11,14);
%

%% 18
% % [~] = main_PML('yeast',5,18);
%[~] = main_PML('yeast',7,18);
%[~] = main_PML('yeast',9,18);
%[~] = main_PML('yeast',11,18);
% % %% 19
%[~] = main_PML('reference',5,19);
%[~] = main_PML('reference',7,19);
%[~] = main_PML('reference',9,19);
%[~] = main_PML('reference',11,19);


% %% 20
% [~] = main_PML('medical',3,20);
% [~] = main_PML('medical',5,20);
% [~] = main_PML('medical',7,20);
% [~] = main_PML('medical',9,20);