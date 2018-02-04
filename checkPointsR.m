function p=checkPointsR(numNodes,p,m,kappa,r)
%function p=checkPointsR(numNodes,p,m,kappa,r)
%
%Checks to see if each point in p has atleast m+1 points in p and kappa
%a distance of r/2 away or less. If not it generates more random points and
%tries again.
%
%INPUTS:
%   numNodes=int=number of nodes to generate
%   p=[numNodes,m]=matrix of all of the points in Rm
%   m=int=the number of dimensions this simulation lives is
%   kappa = [m+1,m]=the location of the anchors in Rm
%
%OUPUTS:
%   p=[numNodes,m]=matrix of all of the points in Rm
   
%   Calculate the distance between each of the points in p and kappa
    dist=getDist(numNodes,p,kappa);
%   Convert the distance to a binary matrix for dist<r/2
    binDist=dist<(r/2);
%   sum each row to find the number of nodes near each node (it does count
%   its self
    numNear=sum(binDist);
    i=0;
%   loop through unitl all of the nodes have 4 neighbors (including its
%   self) or it tries 1000 times.
%   Only look at the nodes, not at the anchors
    while min(numNear(1:numNodes))<(m+2)
        i=i+1;
        %get some points
        p=getPoints(numNodes,m,kappa);
        %calculate the distance
        dist=getDist(numNodes,p,kappa);
        binDist=dist<(r/2);
        %check how many are near
        numNear=sum(binDist);
        if(i>1000)
            error('Error: Cant Find Random Set of Points such that creates convex hull radius')
        end
    end
end
