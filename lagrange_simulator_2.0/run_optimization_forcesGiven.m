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


% Desired force profile over time
Ma_step=1;
% each column in desired_forces_timeSeries is one point in time of the form
% [Ma;forces;contact_points];
desired_forces_timeSeries=transpose(...
    [0,0,0;...
     0,0,0;...
     0,0,0;...
     0,0,0;...
     0,0,0;...
     Ma_step,0,0;...
     Ma_step,0,0;...
     Ma_step,0,0;...
     Ma_step,0,0;...
     Ma_step,0,0;...
    ]...
    );

N_timePoints = size(desired_forces_timeSeries,2);%number of time points;

% Resulting configuration over time with the given force profile. This will
% be optimized
% each column in resulting_states_timeSeries is one point in time of the form
% [q;qdot;qddot] %xx remove qddot?

resulting_states_timeSeries=(rand(3*3,N_timePoints)-0.5)/10;


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
    
    %Build params vector
    params=[ d,...
             L0,...
             E,...
             I,...            
             Aeff,...
             rho_line,...
             g];