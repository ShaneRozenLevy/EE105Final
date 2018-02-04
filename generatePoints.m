function [p,A,B]=generatePoints(kappa,m,numNodes,r)
%function [p,A,B]=generatePoints(kappa,m,numNodes,r)
%
%Generates a set of points given a set of anchors Kappa, a number of nodes,
%and a communication radius r, such that every node is inside the convex
%hull of 3 nodes where the nodes that make up the convex hull are at max a
%distance of r/2 away from the original node.
%
%INPUTS:
%   kappa = [m+1,m]=the location of the anchors in Rm
%   m=int=the number of dimensions of the simulation
%   numNodes=int=the number of nodes to generate
%   r=float=the communication radius
%
%OUTPUTS:
%   p=[numNodes,m]=matrix of the location of all of the points in Rm
%   A=[numNodes,numNodes]=the A matrix for the state space representation
%       of the iterative algorithm. It is derived using the Barycentric
%       cooridnates of the node defined by the nodes in its communication set. 
%   B=[numNodes,m+1]=the B matrix for the state space representation of the
%   tierative algorithm. It is derived using the barycentric coordinates of
%   the node definied by the anchors in its communication set.

%   generate points that are within the convex hull of the anchors, and
%   then check to make sure each node has atleast m+1 nodes or achors a
%   distance of r/2 away or closer. If they are not, checkPointsR will try
%   again with another set pseudo random points
    p=checkPointsR(numNodes,getPoints(numNodes,m,kappa),m,kappa,r);
    
%   Attempt to generate a the A and B matricies for the set of points.
%   Success is if it was completed successfully or not.
    [A,B,success]=developBary(numNodes,p,kappa,r,m);
    j=0;
%   Keep looping until you happen to generate a set of points where each
%   point has a valid communication radius or you have tried 10000 times. 
    while success==false
        j=j+1;
        p=checkPointsR(numNodes,getPoints(numNodes,m,kappa),m,kappa,r);
        [A,B,success]=developBary(numNodes,p,kappa,r,m);
        if(j>10000)
            error('Error: Cannot find valid triangulation set for the given r and number of nodes')
        end
    end
end