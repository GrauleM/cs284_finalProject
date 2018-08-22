function [f,gradf] = objective_dynamicContactPlanner(x,params,obst)
%used in the version that finds the manipulator configurations, time step length h, 
% actuator moments Ma under contact with a round obstacle

L=params(2);

%obstacle obst
h=x(1,1);
states=x(1:6,2:end);
N_timePoints = size(states,2);%number of time points;

N_contacts=(size(x,1)-6-1)/3; %minus 6 for 6 states, minus 1 for tip moment Ma

forces=x(7:7+2*N_contacts+1-1,2:end);
slackVariables=x(7+2*N_contacts+1:end,2:end);

% objective 1: minimize slack variables from contact/complementarity
ob1 = sum(sum(slackVariables,'omitnan'));

ob2=forces(1,:)*forces(1,:)'; %minimize actuator moments

%objective 3: reward high contact force magnitude to encourage the
%occurance of contact
ob3=0;
for i=1:N_contacts
     ob3=ob3-forces(1+i,:)*forces(1+i,:)';
end

% objective 4: reward proximity between the contact point and the
% obstacle
ob4=0;
for i=1:N_contacts
    s_c=forces(1+N_contacts+i,:);
    ob4=ob4+evaluate_guardFn_obstacle(states,s_c,obst,L)*evaluate_guardFn_obstacle(states,s_c,obst,L)';
    %ob4=ob4+sum(evaluate_guardFn_obstacle(states,s_c,obst,L)); %xx this
    %seenms wrong, i.e., it doesnt work

end
ob4=0;


%f=ob1+100000*ob2+ob3+ob4; % this doesnt seem to work (convergence to
%infeasible point
f=ob1+ob2+ob3+ob4;  % but this works
%f=ob1+ob2+ob3+100.*ob4;  
f=ob1+10000000.*ob2+100000.*ob3+ob4;  % xx experimental not sure if this works


end