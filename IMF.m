function [y] = IMF(u, iter_count, limit)

stop = 0;
mean = 0;
min_prev = inf;
max_prev = inf;
zeros_prev = inf;

for i = 1:iter_count
    [min, max, zeros, delta] = localExtreme(u);
    
    if ((isequal(min_prev, length(min)) && isequal(max_prev, length(max)) && isequal(zeros_prev, zeros)))
        stop = stop+1;
    else
        stop = 0;
    end
    
    min_prev = length(min);
    max_prev = length(max);
    zeros_prev = zeros;
    
    if (stop == limit) || (min_prev < 1) || (max_prev < 1)
        fprintf('Limit reached! IMF ends!');
        break;
    end
    
    min_prev = spline(min(:,1), min(:,2), 1:length(u));
    max_prev = spline(max(:,1), max(:,2), 1:length(u));
    mean = (max_prev + min_prev) / 2;
    u = u - mean';
end

y = u;
        

end

