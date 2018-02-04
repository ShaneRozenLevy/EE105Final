function p=getPoints(numNodes,m,kappa)
%function p=getPoints(numNodes,m,kappa)
%
%Generates a random set of points in the convex hull of the points in
%kappa randomly using random barycentric coordinates. 
%
%INPUTS:
%   numNodes=int=number of nodes to generate
%   m=int=the number of dimensions this simulation lives is
%   kappa = [m+1,m]=the location of the anchors in Rm
%
%OUPUTS:
%   p=[numNodes,m]=matrix of all of the points in Rm

%   initialize p so that it is the right size. 
    p=zeros(numNodes,m);
%generate the points randomly
    r=zeros(1,m+1);
    for i=1:numNodes
        %generate m+1 random numbers between 0 and 1 that add up to 1
        %use these as the barycentric coordinates with the anchors to
        %generate the set of points
        r(1)=rand(1);
        for jj=2:m+1
            r(jj)=(1-sum(r(1:(jj-1))))*rand(1);
        end
        %randomize the order of the numbers for more randomness
        r=r(randperm(m+1));
        for j=1:m
            p(i,j)=r*kappa(:,j);
        end
    end
end
