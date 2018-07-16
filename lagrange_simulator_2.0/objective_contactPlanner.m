function [f,gradf] = objective_contactPlanner(x,params)
%used in the version that finds the manipulator configurations, time step length h, 
% actuator moments Ma under contact with a round obstacle

h=x(1,1);
states=x(1:6,2:end);
N_timePoints = size(states,2);%number of time points;

N_contacts=(size(x,1)-6-1)/3; %-6 for 6 states, -1 for tip moment Ma

forces=x(7:7+2*N_contacts+1,2:end);
slackVariables=x(7+2*N_contacts+1:end,2:end);

% objective 1: minimize slack variables from contact/complementarity
ob1 = sum(sum(slackVariables,'omitnan'));

ob2=forces(1,:)*forces(1,:)'; %minimize actuator moments

f=ob1+ob2;

end