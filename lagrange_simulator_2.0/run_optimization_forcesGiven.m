% this file runs the Lagrangian simulator. this version finds the actuator
% states over time given a time series of actuator moments and contact
% forces
% 
% this version (as everything in this
% folder) is intended to be used for constant length elements only. this
% essentially means that the actuator tip force has to be zero, and only
% the actuator tip moment is changed in the optimization

% when using zero contact forces, note: always specify at least one pair of 
% contact force and contact point. specify F_c=0 if no contact force is desired


disp("use version R2017a or newer")

%constraint multiplier to achieve higher accuracy in constraints
constraint_multiplier=10000;

% Desired force profile over time
Ma_step=-15.;

% each column in desired_forces is one point in time of the form
% [Ma;forces;contact_points];
% desired_forces=transpose(...
%     [0,0,0;...
%      0,0,0;...
%      0,0,0;...
%      0,0,0;...
%      0,0,0;...
%      Ma_step,0,0;...
%      Ma_step,0,0;...
%      Ma_step,0,0;...
%      Ma_step,0,0;...
%      Ma_step,0,0;...
%     ]...
%     );

N_timePoints = 50;%number of time points;

N_contacts=1; %number of contact points (at least 1)
desired_forces=zeros(2*N_contacts+1,N_timePoints);

%stepTime=round(N_timePoints/2);
stepTime_point=20;
desired_forces(1,stepTime_point:end)=desired_forces(1,stepTime_point:end)+Ma_step;

% Resulting configuration over time with the given force profile. This will
% be optimized
% structure of states: each colum is one time point of the form [q;qdot]

%decision variables: q and qdot
states0=(rand(2*3,N_timePoints)-0.5)/10; %/1 doesnt work (convergence to infeasible point
%states0=zeros(2*3,N_timePoints); %this seems to work slightly better

h0=.1;   %xx strange: more flopping around for small h0

x0=[states0];

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
options = optimoptions(options,'ConstraintTolerance',1e-10,...
                               'FunctionTolerance',1e-6);
options = optimoptions(options,'SpecifyObjectiveGradient',false,'SpecifyConstraintGradient',false);
options = optimoptions(options,'MaxFunctionEvaluations',10000);

lb = [ ]; ub = [ ];   % No upper or lower bounds
[x,fval] = fmincon(...
    @(x) objective_timeSeriesSimulator(x,params),...
    x0,[],[],[],[],lb,ub,... 
    @(x)allConstraints_timeSeriesSimulator(x,desired_forces,params,constraint_multiplier,h0),...
    options);


%% get q,qdot,qddot %xx change changing array size
states=x;
forces = []; 
all_q = [];
all_qdot = [];
all_qddot = [];

for t=1:N_timePoints-1   %c changes size in loop - not ideal
    
    %forces at this time point (also midpoint
    forces0 = desired_forces(:,t);
    forces1 = desired_forces(:,t+1);
    forces  = [forces,1/2*(forces0+forces1)];
    
    q0      = states(1:3,t);
    qdot0   = states(4:6,t);

    q1      = states(1:3,t+1);
    qdot1   = states(4:6,t+1);

    %midpoints
    all_q       = [all_q,1/2*(q0+q1)];
    all_qdot    = [all_qdot,1/2*(qdot0+qdot1)];

    %approximate qddot
    all_qddot   = [all_qddot,(qdot1-qdot0)/h0];
end


%% plot those states
close all;
states=x;

h1=figure(1);
clf;
axis equal;
hold on;
colors=jet(N_timePoints);
colormap(jet(N_timePoints));
for t=1:N_timePoints
    color=colors(t,:);
    q = states(1:3,t);
    visualize_q(q,L0,h1,color,'-')
end

% use these axis limits for the following plots
xl=xlim;
yl=ylim;

% add colorbar
hc = colorbar;
cb = linspace(1,N_timePoints,N_timePoints);  %xx add step width?
set(hc, 'YTick',(cb-.5)./N_timePoints, 'YTickLabel',cb)
hold off;

% another way to plot this
if 0
    h2=figure(2);
    visualize_q_timeSeries(resulting_states_timeSeries_final(1:3,:),L0,h2,[0,0,0],'-',xl,yl)
end

%% plot tip positions
h3=figure(3);
plot_tipPos_timeSeries(desired_forces,states(1:3,:),L0,h3,h0)
