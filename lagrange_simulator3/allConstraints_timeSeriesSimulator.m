function [c,ceq,DC,DCeq] = allConstraints_timeSeriesSimulator(x,desired_forces,params,constraint_multiplier,h)
%used in the version that finds the manipulator configurations based on a desired time
%series of actuator moments Ma such that the given constraints are met

% x= [desired_forces] for cases where h can be changed
% resulting_states_timeSeries=x(:,2:end);

%for cases with given h:
resulting_states_timeSeries=x;  %x consider cleaning up variable names for consistency accross versions

N_timePoints = size(desired_forces,2);%number of time points;

%doing midpoint dynamics with q and qdot as decision variables and qddot
%computed from qdots
c=[];
ceq=[];

% include dynamics constraints
for t=1:N_timePoints-1   %c,ceq changes size in loop - not ideal
    
    %forces at this time point (also midpoint)
    force0 = desired_forces(:,t);
    force1 = desired_forces(:,t+1);
    force  = 1/2*(force0+force1);
    
    q0      = resulting_states_timeSeries(1:3,t);
    qdot0   = resulting_states_timeSeries(4:6,t);

    q1      = resulting_states_timeSeries(1:3,t+1);
    qdot1   = resulting_states_timeSeries(4:6,t+1);
    
    %midpoints
    q       = 1/2*(q0+q1);
    qdot    = 1/2*(qdot0+qdot1);

    %approximate qddot
    qddot   = (qdot1-qdot0)/h;
    
    %enforce that qdot is the derivative of q at midpoint xx DONT FORGET
    %ME!
    qdot_enf=qdot-(q1-q0)/h;
    
    %enforce lagrangian
    ceq_lagrangian = ...
        compute_lagrangian_constraints(force,q,qdot,qddot,params);
    ceq=[ceq;qdot_enf;ceq_lagrangian];
    
end

% add final state constraint if applicable
ceq_final=[];
ceq=[ceq;ceq_final];

% add start state constraint if applicable
q_desired_start=zeros(3,1);
ceq_start=constraint_StartConfiguration(q_desired_start,resulting_states_timeSeries);
ceq=[ceq;ceq_start];

% add start velocity constraint if applicable
qdot_desired_start=zeros(3,1);
ceq_start=constraint_StartVelocity(qdot_desired_start,resulting_states_timeSeries);
ceq=[ceq;ceq_start];

%add an equality constraint to ensure that final velocity and accelerations
%are zero (equilibrium at the end)
%ceq=[ceq;qdot;qddot];

% add final state constraint if applicable
ceq_final=[];
ceq=[ceq;ceq_final];

% constraint to make sure h is positive
%c=[c;-h];

%constraints need to be row vectors, so fix this..
c=constraint_multiplier*c';
ceq=constraint_multiplier*ceq';

%not supplying gradients for now
DC=constraint_multiplier*[];
DCeq=constraint_multiplier*[];



end