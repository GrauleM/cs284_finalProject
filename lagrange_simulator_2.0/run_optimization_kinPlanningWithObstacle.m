% this file solves the problem of kinematic planning with contacts. 
% this version finds the actuator
% states, tip moments, contact forces, contact points, and integration step
% length for given objective (e.g. final tip position) and obstacle

% this version (as everything in this
% folder) is intended to be used for constant length elements only. this
% essentially means that the actuator tip force has to be zero, and only
% the actuator tip moment is changed in the optimization

% when using zero contact forces, note: always specify at least one pair of 
% contact force and contact point. specify F_c=0 if no contact force is desired

disp("use version R2017a or newer")

% USER INPUT
%obstacle obst=[x_obstacle,y_obstacle,r_obstacle]: obstacle center position and radius
obst=[.45,-.07,.08];

%desired end pose
endPose_des = [1.,-.1,.15*pi];


%constraint multiplier to achieve higher accuracy in constraints
constraint_multiplier=10000;

N_timePoints = 50;%number of time points;
N_contacts=1; %number of contact points (at least 1)

% optimization with following decision variables: actuator moments Ma, step
% width h, contact forces Fc, contact positions along manipulator c, qs, qdots

% also SlackVariables: to relax the complimentarity constraints - these
% need to be driven to zero in the optimization. need one slack variable
% for each complimentarity constraint, so one slcak veriable per contact
% force per time point

% structure of forces: each colum is one time point of the form [Ma,Fc1,Fc2,...,c1,c2]
% structure of states: each colum is one time point of the form [q;qdot]
% structure of x: % x= [h;0;0...., [states;forces;slackVariables] ]
% h: add required zero padding

% initializations
h0=0.1;
states0=(rand(2*3,N_timePoints)-0.5)/10;
forces0=zeros(2*N_contacts+1,N_timePoints); %xx consider other initializations
slackVariables0=(rand(N_contacts,N_timePoints))/10; %not sure this is the best initialization

x0=[[h0;zeros(2*(3+N_contacts)-1,1)], [states0;forces0;slackVariables0]];


