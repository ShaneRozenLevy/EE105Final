function [A,B,success]=developBary(numNodes,p,kappa,r,m)
%function [A,B,success]=developBary(numNodes,p,kappa,r,m)
%
%Given a set of nodes, it calculates the location of a each node as a
%function of the other nodes in its communication set using barycentric
%coordinates. The nodes should each have atleast m+1 nodes a distance of r/2
%away or closer. 
%
%INPUTS:
%   numNodes=int=the number of nodes to generate
%   p=[numNodes,m]=matrix of the location of all of the points in Rm
%   kappa = [m+1,m]=the location of the anchors in Rm
%   r=float=the communication radius
%   m=int=the number of dimensions of the simulation
%
%OUTPUTS:
%   A=[numNodes,numNodes]=the A matrix for the state space representation
%       of the iterative algorithm. It is derived using the Barycentric
%       cooridnates of the node defined by the nodes in its communication set. 
%   B=[numNodes,m+1]=the B matrix for the state space representation of the
%   tierative algorithm. It is derived using the barycentric coordinates of
%   the node definied by the anchors in its communication set.
%   successs=boolean=did this code successful generate the A and B
%   matricies

%   initialize success to false
    success=false;
%   create A and B
    A=zeros(numNodes);
    B=zeros(numNodes,m+1);
%   calculate the distance between each of the nodes
    dist=getDist(numNodes,p,kappa);
    binDist=dist<(r/2);

%   loop through each of the nodes. To check if a node is contained within
%   the convex hull of the nodes a distance of r/2 away or less, look at
%   the size of the convex hull of the node and the nodes a distance r/2
%   away or less. If the size is greater than the size of the convex hull
%   of the nodes a distance of r/2 away or less, than the points are bad.
%   If the sizes are equal, than look to see how many points are a distance
%   of r/2 away or less. If there are m+1 points move to the next node. If
%   there are greater than m+1 points remove a point and check to see if it
%   is contained. Continue trying to remove points unitl you find a set of
%   m+1 points. 
    for i=1:numNodes
        %look at the ith row of bin dist, to see which nodes are a distance
        %of r/2 away or less. Do not look at the ith element of v, since
        %that is the node.
        v=binDist(:,i);
        v(i)=0;
        %possible set of points in Rm that is the possible communication set. 
        possibleSet=[p(v(1:numNodes),:);kappa(v(numNodes+1:end),:)];
        %check the size of the convex hull
        [~,V1]=convhull(possibleSet);
        [~,V2]=convhull([possibleSet;p(i,:)]);
        %if the sizes are the same start looping
        if V1==V2
            l=1;
            %while the there are more than m+1 elements in the possible
            %comunication set, remove an element and test the size of the
            %convex hulls.
            while(length(possibleSet)>m+1)
                %remove the lth element from possible set 
                tempSet=possibleSet([1:l-1,l+1:end],:);
                %look at the size of the convex hulls of the possible set
                %and the possible set with the node.
                [~,V1]=convhull(tempSet);
                [~,V2]=convhull([tempSet;p(i,:)]);
                if V1==V2%if the sizes are equal keep the point removed. 
                         %otherwise incriment l.
                    possibleSet=tempSet;
                    l=1;
                else
                    l=l+1;
                end
            end
        else % if the sizes are not the same in the intial test, success is
             % false and return
            success=false;
            return 
        end
        %now that the set of points is good get the actual values for the ith
        %row of A and B
        [A(i,:),B(i,:)]=getBary(possibleSet,p,i,kappa,m);
    end
    success=true;
end
