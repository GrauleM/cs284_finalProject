% test_code double integrator speedup
L=1;

phi     =@(s,q,qdot,qddot)         q(1).*s./L+q(2)*(s.^2./L.^2-s./L)+q(3)*(2.*s.^3./L.^3-3.*s.^2./L.^2+s./L);

q_val=zeros(3,1);
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
fn1=@(s,q,qdot,qddot) sin(s);
fn2=@(s,q,qdot,qddot) cos(s).*cos(s);

%estimation:
out1=custom_numerical_integrator_2fn(fn1,fn2,q,qdot,qddot,L);
out2=custom_numerical_integrator_2fn_legacySlow(fn1,fn2,q,qdot,qddot,L);

end