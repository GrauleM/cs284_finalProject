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

