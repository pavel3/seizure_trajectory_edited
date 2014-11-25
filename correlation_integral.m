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

temp_val = max(dist(:));
temp_round = abs(floor(log10(temp_val)));
upper_bound = round(temp_val*10^(temp_round))/10^temp_round;

z = 0:upper_bound/1000:upper_bound;
C = zeros(1,length(z));

for j1 = 1:rows
    for j2 = 1:rows
        C = C + heaviside(z - (dist(j1,j2)));
    end
end

C = C./rows^2;
end

