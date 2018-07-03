%test code for custom numerical integration 

sin_fn=@(s,q,qdot,qddot) sin(s*q);

q=1;qdot=0;qddot=0;
L=1;

%% test 1
%test_fn
fn=@(s,q,qdot,qddot) sin(s);
%estimation:
out=custom_numerical_integrator_1fn(fn,q,qdot,qddot,L)
%true solution:
-sin(1)

%% test 2
%test_fn
fn=@(s,q,qdot,qddot) cos(s);
%estimation:
out=custom_numerical_integrator_1fn(fn,q,qdot,qddot,L)
%true solution:
-cos(1)

%% test 5
%test_fn
fn=@(s,q,qdot,qddot) exp(s);
%estimation:
out=custom_numerical_integrator_1fn(fn,q,qdot,qddot,L)
%true solution:
exp(1)-1-(exp(0)-0)

% %% test 3
% %test_fn
% fn=@(s,q,qdot,qddot) s;
% %estimation:
% out=custom_numerical_integrator_1fn(fn,q,qdot,qddot,L)
% %true solution:
% 1/6
% 
% %% test 4
% %test_fn
% fn=@(s,q,qdot,qddot) s^2;
% %estimation:
% out=custom_numerical_integrator_1fn(fn,q,qdot,qddot,L)
% %true solution:
% 1/12