%Shane Rozen-Levy
%EE105 Final Project
%DT Simulation in R2
%
%This project involved recreating much of the work done in our professor's
%paper on a distributed algorithm for sensor localization (U. A. Khan, S. 
%Kar, and J. M. F. Moura, “Linear theory for self-localization: Convexity, 
%barycentric coordinates, and Cayley-Menger determinants,” IEEE Access, 
%vol. 3, pp. 1326–1339, Aug. 2015).
%The first part of the project was a report where we went through most of
%the math to veryify the method. The second part of the project was 4
%different MATLAB simulations. The first simulation was an implimentation
%of the DT algorithm in R2. The second simulation was an implimentation of
%the DT algorithm in R3. The third simulation was an implimentation of the
%CT algorithm in R2. The fourth and final simulation was an implimentation
%of the CT algorithm in R3. 
%
%The algorithm works by having a small number of points that know where
%they are and a large number of points that do not know where they are. The
%points can talk to other points up to a certain distance away and find
%their distance. Each point uses the distance between each neighbor and
%assumes that the neighbors know where they are and updates its posistion.
%The algorithm iterates this process and given a certain criteria on the
%points, the algorithm converges to the true location of the points.
%
%This is the code for the DT simulation in R2
clear

%parameters for the simulation
m=2;
numNodes=4;
r=15;
numTimeSteps=20;
kappa=[0 0; 10 0; 5 10];

%get all the points and A and B
[p,A,B]=generatePoints(kappa,m,numNodes,r);
max(abs(eig(A)))%find spectral radius of A, ensure is less than 1
%initial conditions and matricies for the data
x=abs(10*rand(numNodes, numTimeSteps));
y=abs(10*rand(numNodes, numTimeSteps));

%Solve calculate posisition of nodes over time
for i=2:numTimeSteps
    x(:,i)=A*x(:,i-1)+B*kappa(:,1);
    y(:,i)=A*y(:,i-1)+B*kappa(:,2);
end

figure(10); clf
%plot the anchors
plot([kappa(:,1);kappa(1,1)],[kappa(:,2);kappa(1,2)],'-^','Color','g','Linewidth',2)
hold on
%plot the true location of the nodes
plot(p(:,1),p(:,2),'o','Color','b','Linewidth',3)
%plot nodes over time
for i=1:numNodes
    plot(x(i,:),y(i,:),'--x','Color','b')
end
title(['Location of Points Over Time r=',num2str(r),' numNodes=',num2str(numNodes),' m=',num2str(m)])
legend('Anchors','True Location','Estimate Location')


rmsError=zeros(1,numTimeSteps);
largestError=zeros(1,numTimeSteps);
%calculating error, rms error and max error
for i=1:numTimeSteps
    error=((p(:,1)-x(:,i)).^2+(p(:,2)-y(:,i)).^2).^(1/2);
    rmsError(i)=rms(error);
    largestError(i)=max(abs(error));
end

%plot on the same graph
figure(11); clf
plot(1:numTimeSteps,rmsError,'linewidth',2)
hold on
plot(1:numTimeSteps,largestError,'linewidth',2)
title(['Error Over Time r=',num2str(r),' numNodes=',num2str(numNodes),' m=',num2str(m)])
legend('RMS Error','Largest Error')
ylabel('Error')
xlabel('Time Step')
