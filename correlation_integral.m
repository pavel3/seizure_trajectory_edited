function [ C ] = correlation_integral( time_series, r0 )
%CORRELATION_INTEGRAL Summary of this function goes here
%   Detailed explanation goes here

rows = size(time_series,1);

dist = zeros(rows);

for j1 = 1:rows
    for j2 = 1:rows
        dist(j1,j2) = norm(time_series(j1) - time_series(j2));
    end
end

upper_bound = max(dist(:));

C = 0:upper_bound/1000:upper_bound;
z = C;

for j1 = 1:rows
    for j2 = 1:rows
        C = heaviside(C - (r0 - norm(time_series(j1) - time_series(j2))));
    end
end
end

