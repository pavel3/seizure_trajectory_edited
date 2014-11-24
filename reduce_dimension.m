function reduced_record = reduce_dimension( record_block, explained_threshold)

n_frames		= size(record_block,1);
mean_block		= mean(record_block);

record_block	= record_block - repmat(mean_block,n_frames,1);
cov_block		= record_block'*record_block;
[V D]			= eig(cov_block);
[eigs, eig_idx] = sort(diag(D),'descend');

explained		= eigs/sum(eigs);

V				= V(:,eig_idx);
[~, n_dims]		= min(abs(explained-explained_threshold));
reduced_record	= record_block * V(:,1:n_dims);

end

