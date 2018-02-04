function dist=getDist(numNodes,p,kappa)
%function dist=getDist(numNodes,p,kappa)
%
%Creates a matrix of all of the distance between all elements in both the 
%nodes and the anchors
%
%INPUTS:
%   numNodes=int=number of nodes to generate
%   p=[numNodes,m]=matrix of all of the points in Rm
%   kappa = [m+1,m]=the location of the anchors in Rm
%
%OUPUTS:
%   dist=[numNodes+m+1,numNodes+m+1]=matrix of the distance between all of
%       the points in kappa and nodes. The matrix is symetric. 

%   Setup the size of dist
    dist=zeros(numNodes+length(kappa));
    %loop through the matrix
    for j=1:numNodes+length(kappa)
        for k=1:numNodes+length(kappa)
            if j>numNodes && k>numNodes
                %do bottom corner stuff (so anchor to anchor)
                dist(j,k)=sqrt(sum((kappa(j-numNodes,:)-kappa(k-numNodes,:)).^2));
            elseif j>numNodes
                %distance between anchors and nodes
                dist(j,k)=sqrt(sum((kappa(j-numNodes,:)-p(k,:)).^2));            
            elseif k>numNodes
                %distance between anchors and nodes
                dist(j,k)=sqrt(sum((p(j,:)-kappa(k-numNodes,:)).^2));            
            else
                %distance between nodes and nodes
                dist(j,k)=sqrt(sum((p(j,:)-p(k,:)).^2));
            end  
        end
    end
end
