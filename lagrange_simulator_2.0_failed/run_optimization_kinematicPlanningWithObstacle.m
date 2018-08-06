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


% clear up
clear all; close all;

% USER INPUT
%obstacle obst=[x_obstacle,y_obstacle,r_obstacle]: obstacle center position and radius
obst=[.45,.30,.05];

%desired end pose
endPose_des = [1.,-.1,.15*pi];

%xx care h is set to constant for debugging (in
%allConstraints_contactPlanner

%constraint multiplier to achieve higher accuracy in constraints
constraint_multiplier=10000;

% xx Note: h0=0.1 and N_timePoints=25 with contact constraints but obstacle
% far up converged to a solution

N_timePoints = 15;%number of time points;  %xx note: 15 time points required 9k function evaluations without contact
N_contacts=1; %number of contact points (at least 1)

% optimization with following decision variables: actuator moments Ma, step
% width h, contact forces Fc, contact positions along manipulator c, qs, qdots

% also SlackVariables: to relax the complimentarity constraints - these
% need to be driven to zero in the optimization. need one slack variable
% for each complimentarity constraint, so one slcak veriable per contact
% force per time point

% structure of forces: each colum is one time point of the form [Ma,Fc1,Fc2,...,c1,c2,... cN]
% structure of states: each colum is one time point of the form [q;qdot]
% structure of x: % x= [h;0;0...., [states;forces;slackVariables] ]
% h: add required zero padding

INITIALIZE=0; %if set to one, use old contact free states for initialization


% initializations
h0=0.1;
states0=(rand(2*3,N_timePoints)-0.5)/10; %this didnt work yet
states0=zeros(2*3,N_timePoints); 




forces0=zeros(2*N_contacts+1,N_timePoints); %xx consider other initializations

forces0(2:2+N_contacts-1,:) = 50.*(rand(1,N_timePoints)-.5);
forces0(1+N_contacts+1:end,:)=rand(N_contacts,N_timePoints); %initialize all contact locations to be between 0 and 1
slackVariables0=(rand(N_contacts,N_timePoints))/1.; %not sure this is the best initialization

if INITIALIZE %initialize states with solution from obstacle free simulation
    load('saved_xfinal_ContactAbove_newObjective_30timepoints.mat','x_final','h_final');
    states0=x_final(1:6,2:end); %states
    forces0(1,:)=x_final(7,2:end); %tip moments
    forces0(2:2+N_contacts-1,:)=x_final(8:8+N_contacts-1,2:end); %contact forces
    slackVariables0=x_final(8+N_contacts-1+N_contacts+1:end,2:end);
    h0=h_final;
end

x0=[[h0;zeros(2*3+1+3*N_contacts-1,1)], [states0;forces0;slackVariables0]];

%Params
    %Actuator geometries
    r_actuator=0.02; %actuator outer diameter in meter
    r_actuator_in=0.015; %actuator inner diameter in meter
    I_actuator=1./4.*pi*(r_actuator^4-r_actuator_in^4); %moment of inertia of actuator
    A_actuator=pi.*(r_actuator^2-r_actuator_in^2); %area of one actuator
    Aeff=2.*A_actuator; %effective area (for two actuators)
    d=0.05; %distance from center (spine) to middle of actuator
    L0=1; %unstretched length in m
    
    %combined actuator density (line density of both actuators along backbone
    rho_line=5; %xx tune this value
    
    %Stiffness
    E=0.005*10^9; %the Youngs modulus of silicone rubber is 0.05GPa; we actually have a much lower stiffness due to flexures
    I=2.*(I_actuator+d^2.*A_actuator); %moment of inertia of two actuators offset from backbone
    
    %Gravity
    g=9.81; %duh
    
    %damping coefficients
    b=1;
    b1=1*b;
    b2=1*b;
    b3=1*b;

    %Build params vector
    params=[ d,...
             L0,...
             E,...
             I,...            
             Aeff,...
             rho_line,...
             g,...
             b1,...
             b2,...
             b3,...
             ];
         
        
% finally run the optimization
options = optimoptions(@fmincon,'Algorithm','sqp','Display','iter');
options = optimoptions(options,'ConstraintTolerance',1e-6,...
                               'FunctionTolerance',1e-6);
options = optimoptions(options,'SpecifyObjectiveGradient',false,'SpecifyConstraintGradient',false);
options = optimoptions(options,'MaxFunctionEvaluations',30000);

lb = [ ]; ub = [ ];   % No upper or lower bounds
[x_final,fval] = fmincon(...
    @(x) objective_kinematicContactPlanner(x,params,obst),...
    x0,[],[],[],[],lb,ub,... 
    @(x)allConstraints_kinematicContactPlanner(x,params,constraint_multiplier,obst),...
    options);

%% unpack states and plot
close all;
h_final=x_final(1,1);

if 1 %if h was set to be constant previously
    h_final=0.1;
end
states_final=x_final(1:6,2:end);
forces_final=x_final(7:7+2*N_contacts+1-1,2:end);

h1=figure(1);
clf;
axis equal;
hold on;
colors=jet(N_timePoints);
colormap(jet(N_timePoints));
for t=1:N_timePoints
    color=colors(t,:);
    q = states_final(1:3,t);
    visualize_q(q,L0,h1,color,'-')
end

% use these axis limits for the following plots
xl=xlim;
yl=ylim;

% add colorbar
hc = colorbar;
cb = linspace(1,N_timePoints,N_timePoints); %xx add step width?
set(hc, 'YTick',(cb-.5)./N_timePoints, 'YTickLabel',cb)
viscircles(obst(1:2),obst(3)) % draw the cicular obstacle
hold off;

%% plot tip positions
h3=figure(3);
plot_tipPos_timeSeries(forces_final,states_final(1:3,:),L0,h3,h_final)

%% save x_final
if 0
   save('saved_xfinal_ContactBelow_newObjective_30timepoints_initializedFailed.mat');
end

%% 
%check penetration constraints
%p_test=penetration_constraints(states0,obst,L0)

