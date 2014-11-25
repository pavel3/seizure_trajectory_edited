function segment_data
% 
% %% TT 100Hz
% clear
% load('Data/SeizureData.mat', 'x2');
% 
% fs_raw					= 2000;
% fs						= fs_raw/20;
% 
% raw_data				= x2(:,3e6:5e6);
% [n_channels n_frames]	= size(raw_data);
% 
% record_block			= [];
% for c1 = 1:n_channels
% 	record_block(c1,:)  = resample(raw_data(c1,:), 1, 20);
% end
% record_block = record_block';

% if exist('Data/TT_2_2_100Hz.mat','file')
% 	save('Data/TT_2_2_100Hz.mat', 'record_block','fs', '-append');
% else
% 	save('Data/TT_2_2_100Hz.mat', 'record_block','fs');
% end
% clear
% 
% %% TT 500Hz
% load('Data/SeizureData.mat');
% record_block	= [];
% fs				= fs_raw/4;
% for c1 = 1:n_channels
% 	sz_2_2(c1,:)  = resample(raw_data(c1,:), 1, 4);
% end
% 
% if exist('Data/sz_2_2_500Hz.mat','file')
% 	save('Data/sz_2_2_500Hz.mat', 'sz_2_2','fs', '-append');
% else
% 	save('Data/sz_2_2_500Hz.mat', 'sz_2_2','fs');
% end
% 
% %% KA 100Hz
% load('Data/KA_08012014.mat');
% raw_data	= x(:,1:1.5e6);
% [n_channels n_frames] = size(raw_data);
% 
% record_block	= [];
% fs		= fs_raw/20;
% for c1 = 1:n_channels
% 	record_block(c1,:)  = resample(raw_data(c1,:), 1, 20);
% end
% record_block = record_block';
% save('Data/KA_1_1_100Hz.mat', 'record_block','fs');
% end

%% Control 100Hz
clear
load('Data/original data/kainic acid.mat');

fs_raw					= 2000;
fs						= fs_raw/20;

raw_data				= x(:,1:2e6) / 1000;
[n_channels n_frames]	= size(raw_data);

record_block	= [];
for c1 = 1:n_channels
	record_block(c1,:)  = resample(raw_data(c1,:), 1, 20);
end

record_block = record_block';
save('Data/KA_100Hz.mat', 'record_block', 'fs');
end

