
function output = oneOutOfC(input)
numClass = length(unique(input));

N = length(input);

output = zeros(numClass,N);

 label =    unique(input);
for i  = 1: N
    
 [ ~,~,pos ]=   intersect(input(i),label);
  output(pos,i) = 1;
end

