function [c,ceq,DC,DCeq] = allConstraints_dynamicContactPlanner(x,params,constraint_multiplier,obst)
%used in the version that finds the manipulator configurations, time step length h, 
% actuator moments Ma under contact with a round obstacle

L=params(2);

% reminder structure of x: x= [h;0;0...., [states;forces] ]


h=x(1,1);
h=0.1; %xx careful debug hack - avoid changing h size

states=x(1:6,2:end);
N_timePoints = size(states,2);%number of time points;

N_contacts=(size(x,1)-6-1)/3; %-6 for 6 states, -1 for tip moment Ma

forces=x(7:7+2*N_contacts+1-1,2:end);
slackVariables=x(7+2*N_contacts+1:end,2:end);


%doing midpoint dynamics with q and qdot as decision variables and qddot
%computed from qdots
c=[];
ceq=[];

% include dynamics constraints
for t=1:N_timePoints-1   %c,ceq changes size in loop - not ideal
    
    %forces at this time point (also midpoint)
    force0 = forces(:,t);
    force1 = forces(:,t+1);
    force  = 1/2.*(force0+force1);
    
    q0      = states(1:3,t);
    qdot0   = states(4:6,t);

    q1      = states(1:3,t+1);
    qdot1   = states(4:6,t+1);
    
    %midpoints
    q       = 1/2.*(q0+q1);
    qdot    = 1/2.*(qdot0+qdot1);

    %approximate qddot
    qddot   = (qdot1-qdot0)./h;
    
    %enforce that qdot is the derivative of q at midpoint xx DONT FORGET
    %ME!
    qdot_enf=qdot-(q1-q0)./h;
    
    %enforce lagrangian
    ceq_lagrangian = ...
        compute_lagrangian_constraints(force,q,qdot,qddot,params);
    ceq=[ceq;qdot_enf;ceq_lagrangian];
    
end

% % include dynamics constraints in potentially more efficient way
% 
% % midpoint q and qdot
% midpoint_states=(states(:,1:N_timePoints-1)+states(:,2:N_timePoints))/2;
% %approximate qdot as diff of q and qddot as difference of qdot
% % i.e.    qddot   = (qdot1-qdot0)/h; qdot = (q1-q0)/h;
% midpoint_derivatives=(states(:,2:N_timePoints)+states(:,1:N_timePoints-1))/h;
% 
% %midpoint forces (%defined as constant from time k) xx may be better to use
% %average here?
% 
%  %constraint to enforce that qdot is the derivative of q at midpoint xx DONT FORGET
%     %ME!
% qdot_enf=midpoint_states(4:6,:)-midpoint_derivatives(1:3,:);    
% ceq=qdot_enf(:);  %xx care to not have any other constraints before this
% for t=1:N_timePoints-1   %c,ceq changes size in loop - not ideal
%     
%     %forces at this time point (NOT midpoint)
%     force  = forces(:,t);
%     
%     %midpoints
%     q       = midpoint_states(1:3,t);
%     qdot    = midpoint_states(4:6,t);
% 
%     %approximate qddot
%     qddot   = midpoint_derivatives(4:6,t);
%         
%     %enforce lagrangian
%     ceq_lagrangian = ...
%         compute_lagrangian_constraints(force,q,qdot,qddot,params);
%     ceq=[ceq;ceq_lagrangian];
%     
% end


% add final state constraint if applicable
ceq_final=[];
ceq=[ceq;ceq_final];


%add an equality constraint to ensure that final velocity and accelerations
%are zero (equilibrium at the end). xx be very careful with this constraint.
%only add it, if h is variable. even then, it may lead to infeasible
%solutions. may be better to have this in the objective
%ceq=[ceq;qdot;qddot];

% add start state constraint if applicable
q_desired_start=zeros(3,1);
ceq_start=constraint_StartConfiguration(q_desired_start,states);
ceq=[ceq;ceq_start];

% add start velocity constraint if applicable
qdot_desired_start=zeros(3,1);
ceq_start=constraint_StartVelocity(qdot_desired_start,states);
ceq=[ceq;ceq_start];


% constraint to make sure h is positive
c=[c;-h];

% add constraints to ensure that the manipulator doesnt penetrate the
% obstacle at any time point
c_pen=penetration_constraints(states,obst,L);
c=[c;c_pen];

% add constraints for contact forces
[c_contact,ceq_contact]=contact_constraints(states,forces,slackVariables,obst,L);
c=[c;c_contact];
ceq=[ceq;ceq_contact];

%constraints need to be row vectors, so fix this..
c=constraint_multiplier*c';
ceq=constraint_multiplier*ceq';

%not supplying gradients for now
DC=constraint_multiplier*[];
DCeq=constraint_multiplier*[];



end