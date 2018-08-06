%TEST CODE FOR CUSTOM NUMERICAL INTEGRATION

%% test code for custom_numerical_integrator_1fn.m
q=[1;1;1];qdot=[0;0;0];qddot=[0;0;0];
L=2;

% test 1
%test_fn
fn=@(s,q,qdot,qddot) sin(s);
%estimation:
out=custom_numerical_integrator_1fn(fn,q,qdot,qddot,L)
%true solution:
-sin(L)+L

% test 2
%test_fn
fn=@(s,q,qdot,qddot) cos(s);
%estimation:
out=custom_numerical_integrator_1fn(fn,q,qdot,qddot,L)
%true solution:
-cos(L)+cos(0)

% test 3
%test_fn
fn=@(s,q,qdot,qddot) s;
%estimation:
out=custom_numerical_integrator_1fn(fn,q,qdot,qddot,L)
%true solution:
1/6*L^3

% test 4
%test_fn
fn=@(s,q,qdot,qddot) s.^2;
%estimation:
out=custom_numerical_integrator_1fn(fn,q,qdot,qddot,L)
%true solution:
1/12*L^4

% test 5
%test_fn
fn=@(s,q,qdot,qddot) exp(s);
%estimation:
out=custom_numerical_integrator_1fn(fn,q,qdot,qddot,L)
%true solution:
exp(L)-L-(exp(0)-0)

% test 6
%test_fn
fn=@(s,q,qdot,qddot) s.^2;
%estimation:
out=custom_numerical_integrator_1fn(fn,q,qdot,qddot,0.3.*L)
%true solution:
1/12*(0.3.*L)^4

%% test code for custom_numerical_integrator_2fn.m
q=1;qdot=0;qddot=0;
L=1;

% test 1
fn1=@(s,q,qdot,qddot) cos(s);
fn2=@(s,q,qdot,qddot) cos(s);
%estimation:
out=custom_numerical_integrator_2fn(fn1,fn2,q,qdot,qddot,L)
%true: 
1/2*(L-sin(L)*cos(L))-1/2*(0-sin(0)*cos(0))

% test 2
fn1=@(s,q,qdot,qddot) 2*s;
fn2=@(s,q,qdot,qddot) s;
%estimation:
out=custom_numerical_integrator_2fn(fn1,fn2,q,qdot,qddot,L)
%true: 
1/10*L^5