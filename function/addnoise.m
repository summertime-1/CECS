function [pLabels,data,target] = addnoise(dataname,avg_cls)
%用于加噪声和调用数据集
    load(dataname);
    tf1 = strcmp(dataname,'music_emotion');
    tf2 = strcmp(dataname,'music_style');
    tf3 = strcmp(dataname,'mirflickr');
    tf4 = strcmp(dataname,'YeastBP');
    tf = tf1+tf2+tf3+tf4;
        if tf == 1
            target = target';            
            if tf4 == 1
                pLabels = partial_labels';
            else
                pLabels = candidate_labels';
            end  
        else
            [pLabels, noisy_nums] = rand_noisy_num_new(target,avg_cls);
        end

end