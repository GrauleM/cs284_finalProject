% this file runs the Lagrangian simulator. this version finds the actuator
% states over time given a time series of actuator moments and contact
% forces
% 
% this version (as everything in this
% folder) is intended to be used for constant length elements only. this
% essentially means that the actuator tip force has to be zero, and only
% the actuator tip moment is changed in the optimization

% using zero contact forces. note: always specify at least one pair of 
% contact force and contact point. specify F_c=0 if no contact force is desired

%constraint multiplier to achieve higher accuracy in constraints
constraint_multiplier=100000000;

% Desired force profile over time
Ma_step=2.;

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

N_timePoints = 40;%number of time points;

N_contacts=1; %number of contact points (at least 1)
desired_forces=zeros(2*N_contacts+1,N_timePoints);

%stepTime=round(N_timePoints/2);
stepTime=10;
desired_forces(1,stepTime:end)=desired_forces(1,stepTime:end)+Ma_step;

% Resulting configuration over time with the given force profile. This will
% be optimized
% each column in resulting_states_timeSeries is one point in time of the form
% [q;qdot;qddot] %xx remove qddot?

%decision variables: q and qdot
resulting_states_timeSeries0=(rand(2*3,N_timePoints)-0.5)/10;
%resulting_states_timeSeries0=zeros(2*3,N_timePoints); %this seems to work
%slightly better

h0=1;   %xx strange: more flopping around for small h0

% %bundle decision variables for cases where h is a decision variable (e.g.
% %when looking to achieve final desired tip position)
% % x= [h;0;0...., desired_forces]
% h_vec=[h0;zeros(size(resulting_states_timeSeries0,1)-1,1)];
% x0=[h_vec,resulting_states_timeSeries0];

x0=[resulting_states_timeSeries0];

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
    rho_line=1; %xx tune this value
    
    %Stiffness
    E=0.005*10^9; %the Youngs modulus of silicone rubber is 0.05GPa; we actually have a much lower stiffness due to flexures
    I=2.*(I_actuator+d^2.*A_actuator); %moment of inertia of two actuators offset from backbone
    
    %Gravity
    g=9.81; %duh
    
    %damping coefficients
    b=10;
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
options = optimoptions(options,'MaxFunctionEvaluations',10000);

lb = [ ]; ub = [ ];   % No upper or lower bounds
[x,fval] = fmincon(...
    @(x) objective_timeSeriesSimulator(x,params),...
    x0,[],[],[],[],lb,ub,... 
    @(x)all_constraints_timeSeriesSimulator(x,desired_forces,params,constraint_multiplier,h0),...
    options);


%% plot those states
close all;
resulting_states_timeSeries_final=x;

h1=figure(1);
clf;
axis equal;
hold on;
colors=jet(N_timePoints);
colormap(jet(N_timePoints));
for t=1:N_timePoints
    color=colors(t,:);
    q = resulting_states_timeSeries_final(1:3,t);
    visualize_q(q,L0,h1,color,'-')
end

% use these axis limits for the following plots
xl=xlim;
yl=ylim;

% add colorbar
hc = colorbar;
cb = linspace(1,N_timePoints,N_timePoints);
set(hc, 'YTick',(cb-.5)./N_timePoints, 'YTickLabel',cb)
hold off;

% another way to plot this
if 0
    h2=figure(2);
    visualize_q_timeSeries(resulting_states_timeSeries_final(1:3,:),L0,h2,[0,0,0],'-',xl,yl)
end