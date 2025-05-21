function par = params_settings(ttt)
%参数配置
params = [1e-1, 1e-2, 1e-2, 1e-1, 1e1, 0.8;     % 1.mirflickr
          1e-1, 1e-2, 1e-2, 1e-1, 1e1, 0.2;     % 2.music_emotion
          1e-1, 1e-2, 1e-2, 1e-1, 1e0, 0.2 ;     % 3.music_style
          1e-1, 1e-2, 1e-3, 1e-1, 1e0, 0.2 ;     % 4.YeastBP
          1e-2, 1e-3, 1e-2, 1e-1, 1e0, 0.2 ;     % 5.emotions, 3.
          1e-1, 1e-3, 1e-3, 1e-1, 1e1, 0.2 ;     % 6.emotions, 4, 5.
          1e-1, 1e-2, 1e-2, 1e-1, 1e-1, 0.2 ;    % 7.birds.
          1e-2, 1e-2, 1e-2, 1e-1, 1e1, 0.2;     % 8.flags.
          1e-1, 1e-2, 1e-1, 1e-2, 1e2, 0.2 ;    % 9.foodtruck.
          1e-1, 1e-2, 1e-3, 1e-1, 1e-3, 0.2 ;     % 10.image.2
          1e-1, 1e-2, 1e-3, 1e-1, 1e-1, 0.2 ;     % 11.image.3,4
          1e-1, 1e-2, 1e-3, 1e-2, 1e1, 0.2;    % 12.scene.
          1e-1, 1e-2, 1e-3, 1e-2, 1e-1, 0.2 ;    % 13.health.
          1e-2, 1e-3, 1e-3, 1e-3, 1e1, 0.2 ;    % 14.recreation.
          1e-3, 1e-3, 1e0, 1, 1, 1;     % 15.science.
          1e-3, 1e-3, 1e0, 1, 1, 1 ;     % 16.eduction.
          1e-3, 1e-3, 1e0, 1, 1, 1 ;    % 17.arts.
          1e-1, 1e-2, 1e-3, 1e-1, 1e1, 0.8;    % 18.yeast.
          1e-3, 1e-3, 1e0, 1, 1, 1 ;     % 19.reference
          1e-1, 1e-2, 1e-3, 1e-1, 1e-1, 0.9;    % 20.medical.
          1e-3, 1e-3, 1e0, 1, 1, 1;     % 21.corel5k
          1e-3, 1e-3, 1e0, 1, 1, 1 ;     % 22.enron
          ];
par = params(ttt,:);
end