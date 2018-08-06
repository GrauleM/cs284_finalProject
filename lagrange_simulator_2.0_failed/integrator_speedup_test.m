% test_code integrator speedup
L=1;

phi     =@(s,q,qdot,qddot)         q(1).*s./L+q(2)*(s.^2./L.^2-s./L)+q(3)*(2.*s.^3./L.^3-3.*s.^2./L.^2+s./L);

q_val=ones(3,1);
qdot_val=zeros(3,1);
qddot_val=zeros(3,1);

% s=[0.5;10];
% 
% phi(s,q_val,qdot_val,qddot_val)


%TEST CODE FOR CUSTOM NUMERICAL INTEGRATION

%% test code for custom_numerical_integrator_1fn.m
q=1;qdot=0;qddot=0;
L=2;

for i=1:10000
% test 1
%test_fn
fn1=@(s,q,qdot,qddot) sin(phi(s,q,qdot,qddot));
%estimation:
out1=custom_numerical_integrator_1fn(fn1,q_val,qdot_val,qddot_val,L);
out2=custom_numerical_integrator_1fn_legacySlow(fn1,q_val,qdot_val,qddot_val,L);
%true solution:
-sin(L)+L;

% test 2
%test_fn
fn2=@(s,q,qdot,qddot) cos(s);
%estimation:
out1=custom_numerical_integrator_1fn(fn2,q,qdot,qddot,L);
out2=custom_numerical_integrator_1fn_legacySlow(fn2,q,qdot,qddot,L);
%true solution:
-cos(L)+cos(0);

% speed_test
%test_fn
fn_speed=@(s,q,qdot,qddot) sin(s).*cos(s)+exp(sin(s));   %XX CARE WITHE sin(s)*sin(s) vs .*
%estimation:
out1=custom_numerical_integrator_1fn(fn_speed,q,qdot,qddot,L);
out2=custom_numerical_integrator_1fn_legacySlow(fn_speed,q,qdot,qddot,L);
end