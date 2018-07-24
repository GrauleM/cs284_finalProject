function [f,gradf] = objective_timeSeriesSimulator(x,params)
% used in the version that finds the manipulator configurations based on a desired time
% series of actuator moments Ma such that the last configuration has zero
% velocity and zero acceleration (enforced at midpoint between last and
% second-to-last time points

% possible objective: minimize h; this means to get stable as fast as possible. not
% sure this is the ideal objective

% objective below: no velocity at final position

f=1;

end