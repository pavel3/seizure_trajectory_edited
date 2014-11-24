function trajectory
clear
clc
FILE_NAME	= 'Data/segmented data/CT_1_1_100Hz';
load(FILE_NAME, 'record_block', 'fs');

STEP_SIZE		= 10;
WINDOW_SIZE		= 10;
N_DELAY			= 5;
N_SURROGATE		= 5;


tau						= find_tau(record_block);
[embeded embeded_t] 	= construct_phase_space(record_block, tau, N_DELAY, fs);
reduced_block			= reduce_dimension(embeded, 1e-3);
[D D_t]					= correlation_density(reduced_block, STEP_SIZE, WINDOW_SIZE, fs);

surrogate_block			= phaseran(record_block, N_SURROGATE);
for c1 = 1:size(surrogate_block,3)
	c1
	embeded_surrogate	= construct_phase_space(squeeze(surrogate_block(:,:,c1)), tau, N_DELAY, fs);
	reduced_block		= reduce_dimension(embeded_surrogate, 1e-3);
	D_surrogate(:,c1)	= correlation_density(reduced_block, STEP_SIZE, WINDOW_SIZE, fs);
end

% save([FILE_NAME sprintf(' STEP_SIZE %ds - WINDOW_SIZE %d - N_DELAY %d', ...
% 	STEP_SIZE, WINDOW_SIZE, N_DELAY) '.mat'],...
% 	'D_t', 'D', 'D_surrogate', ...
% 	'STEP_SIZE', 'WINDOW_SIZE', 'N_DELAY', ...
% 	'embeded_t', 'embeded', 'embeded_surrogate', 'record_block');

end

function C = correlation_integral(window, w, r0)

K		= size(window,1);
count	= 0;
dist	= nan(K^2,1);
for t = 1:K
	for s = t+1+w:K
		count		= count + 1;
		dist(count) = norm(window(t,:) - window(s,:), inf);		
	end
end

dist = dist(1:count);
if nargin == 2
	C = median(dist);
else
	C = mean(dist < r0);
end

end

function [D t_D] = correlation_density(phase_space, step_size, window_size, fs)

window_frames	= window_size * fs;
step_frames		= step_size * fs;
count	= 1;
r0		= correlation_integral(phase_space(1:window_frames, :), 25);

for c1 = step_frames+1:step_frames:size(phase_space,1)-window_frames
	D(count)	= correlation_integral(phase_space(c1:c1+window_frames-1, :), 125, r0);
	t_D(count)	= (c1+window_frames-1)/fs;
	count		= count + 1;
end

end

function tau = find_tau(signal)

tau	= nan(size(signal,2),1);
for c1 = 1:size(signal,2)
	c	= xcorr(signal(:,c1),signal(:,c1));
	c	= c(ceil(size(c,1)/2):end);
	
	for c2 = 1:length(c) 
		if c(c2) < 0 && c(c2-1) > 0
			tau(c1) = c2;
			break;
		end
	end
	
end
tau = median(tau);
% [~, tau]	= min(abs(c/max(c))-max_autocorr);
end

function [phase_space t] = construct_phase_space(record_block, tau, n_delay, fs)

[n_frames, n_channels]	= size(record_block);
phase_space				= nan(n_frames-n_delay*tau, n_channels*(n_delay+1));

for c1 = 1+n_delay*tau : n_frames
	
	delay_vector = nan(1, n_channels*(n_delay+1));
	for c2 = 0:n_delay
		
		% 0 1-16   c2*n_channel+1	(c2+1)*n_channel
		% 1 17-32  c2*n_channel+1	(c2+1)*n_channel
		% 2 33-48
		% 3 49-64
		delay_vector(c2*n_channels+1 : (c2+1)*n_channels) = record_block(c1 - c2*tau,:);
	
		
		
	end
	phase_space(c1-n_delay*tau,:)	= delay_vector;
	t(c1-n_delay*tau)				= c1/fs;
	
	
end

end

