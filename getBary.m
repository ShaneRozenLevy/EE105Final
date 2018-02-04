function [A,B]=getBary(possibleSet,p,i,kappa,m)
%function [A,B]=getBary(possibleSet,p,i,kappa,m)
%
%
%
%INPUTS:
%   possibleSet=[m+1,m]=the location of points in the communication set 
%   p=[numNodes,m]=matrix of the location of all of the points in Rm
%   i=int=the element in p that the A and B row is for
%   kappa= [m+1,m]=the location of the anchors in Rm
%   m=int=the dimension for the simulation
%
%OUPTUS:
%   A=[1,numNodes]=the A matrix for the state space representation
%       of the iterative algorithm. It is derived using the Barycentric
%       cooridnates of the node defined by the nodes in its communication set. 
%   B=[1,m+1]=the B matrix for the state space representation of the
%   tierative algorithm. It is derived using the barycentric coordinates of
%   the node definied by the anchors in its communication set.

    A=zeros(1,length(p));
    B=zeros(1,m+1);
    %join together p and kappa
    fullset=[p;kappa];
    %loop through each element in the communication set
    for z=1:length(possibleSet)
       %use fancy boolean to find which rom in the fullset is the same as
       %the row of the communication set. 
       node=fullset==possibleSet(z,:);
       node=sum(node,2);
       node=m==node;
       node=find(node);
       %Calculate the area for use in the barycentric coordinates. Area is
       %the size of the convex hull of the communication set. This is the
       %denomenator of the barycentric coordinate. area is the size of the
       %convex hull of the communication set without the current point in
       %the communication set and with the node. It is the numerator of the
       %barycentric coordinate. 
       [~,Area]=convhull(possibleSet);
       [~,area]=convhull([possibleSet([1:z-1,z+1:end],:);p(i,:)]);
       %check if the point of the communication set is an anchor or not
       if node>length(p)
           B(node-length(p))=area/Area;
       else
           A(node)=area/Area;
       end
    end
end