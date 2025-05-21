function [Lr,C] = relate3(Y)
%计算标签相关性
[N, class] = size(Y);

P = zeros(class, class);
for i=1:class
    for j=1:class
    
       if sum(Y(:,i))==0
           P(i,j) = 0;
       else    
       % P(i,j) = (Y(:,i)'* Y(:,j))/sum(Y(:,i));   
       P(i,j) = (Y(:,i)'* Y(:,j))/(norm(Y(:,i),2)*norm(Y(:,i),2)); 
       if P(i,j)>1
           P(i,j) = 1;
       end
       end 
    end 
end
D = diag(sum(P,2));
C = P;
Lr = D - P;
Lr = 1/2*(Lr'+Lr);

end
