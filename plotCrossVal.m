function  plotCrossVal(inputStruct)
%PLOTCROSSVAL Plot function for outPut Struct from "crossValidation" func
[m,n,l]=size(inputStruct);
q=1;
figure
for i=1:m
    for j=1:n
        subplot(3,3,q);
        plot(1:length(inputStruct(i,j).Acc),inputStruct(i,j).Acc);hold on;
        plot(1:length(inputStruct(i,j).Acc),...
            ones(1,length(inputStruct(i,j).Acc))*mean(inputStruct(i,j).Acc),'r--');
        hold off;
        xlabel('K-fold iteration');
        ylabel('Accuracy');
        title([' Neigh. ',num2str(inputStruct(i,j).Neighbors),...
               ' WindS.: ',num2str(inputStruct(i,j).WindowSize),...
               ' Type: ',num2str(inputStruct(i,j).dataType),...
               ' Dist.: ',num2str(inputStruct(i,j).distance)]);
        grid on;
        legend('K-fold Acc.',num2str(mean(inputStruct(i,j).Acc)),...
            'Location','Best');
        ylim([0.85 1]);
        q=q+1;
        if q==10
            figure
            q=1;
        end
    end
end
end

