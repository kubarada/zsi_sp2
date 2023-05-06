function [min, max, zeros, delta] = localExtreme(u)

min = [];
max = [];
zeros = 0;

for i = 2:length(u)-1
    if (u(i)<u(i-1)) && (u(i) <= u(i+1))
        min(end+1, 1) = i;
        min(end, 2) = u(i);
   
    elseif (u(i)>u(i-1)) && (u(i) >= u(i+1))
        max(end + 1,1) = i;
        max(end, 2) = u(i);

    end
    
    if zeroCrossing(u(i-1)) ~= zeroCrossing(u(i))
        zeros = zeros + 1;
    end
delta = length(min) + length(max) - zeros;    
end

end

