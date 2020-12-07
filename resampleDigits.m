function digitsArray = resampleDigits(digits,P)
% Resample digits cell array with shape {n}{m} to double array {n}*{m} with
% unit length {P}
%   INPUT: digits - cell array with samples
%          P - desired unit length
%   OUTPUT: digitsArray - resampled digitsArray
[~,n,~]=size(digits);
[~,m,~]=size(digits{1});

digitsArray=zeros(n*m,P,2);
for i=1:n
    for j=1:m
         buff=resample(digits{i}{j}...
             ,P,length(digits{i}{j}(:,1)));
         digitsArray((i-1)*100+j,:,:)=buff;
    end
end
end

