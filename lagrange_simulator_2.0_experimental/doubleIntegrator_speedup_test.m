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
q=1;qdot=2;qddot=3;
L=1.;
% test 1
%test_fn
fn1=@(s,q,qdot,qddot) sin(s);
fn2=@(s,q,qdot,qddot) cos(s).*cos(s);

%estimation:
out1=custom_numerical_integrator_2fn(fn1,fn2,q,qdot,qddot,L)
out2=custom_numerical_integrator_2fn_legacySlow(fn1,fn2,q,qdot,qddot,L)


%% more complex cases:

L=1;

phi     =@(s,q,qdot,qddot,L)     q(1).*s./L+q(2).*(s.^2./L.^2-s./L)+q(3).*(2.*s.^3./L.^3-3.*s.^2./L^2+s./L);
phidot  =@(s,q,qdot,qddot,L)  qdot(1).*s./L+qdot(2).*(s.^2./L.^2-s./L)+qdot(3).*(2.*s.^3./L.^3-3.*s.^2./L^2+s./L);

phi2     =@(s,q,qdot,qddot)     q(1).*s./L+q(2).*(s.^2./L.^2-s./L)+q(3).*(2.*s.^3./L.^3-3.*s.^2./L^2+s./L);


testFn=@(s,q,qdot,qddot,L) s;

phi_dq=@(s,q)               [s./L;...
                             (s.^2./L.^2-s./L);...
                             (2.*s.^3./L.^3-3.*s.^2./L.^2+s./L)];
phidot_dqdot=@(s,qdot)      [s./L;...
                             (s.^2./L.^2-s./L);...
                             (2.*s.^3./L.^3-3.*s.^2./L.^2+s./L)];
                         
% various integration helper functions
% these functions need to be integrated from 0 to s to get x(s) and y(s)        
x_helper=@(s,q,qdot,qddot)          cos(phi(s,q,qdot,qddot,L));
y_helper=@(s,q,qdot,qddot)          sin(phi(s,q,qdot,qddot,L));
% this function needs to be integrated from 0 to s to get dx(s)/dq and dy(s)/dq        
x_dq_helper=@(s,q,qdot,qddot)       -sin(phi(s,q,qdot,qddot,L)).*phi_dq(s,q);   
y_dq_helper=@(s,q,qdot,qddot)       cos(phi(s,q,qdot,qddot,L)).*phi_dq(s,q);   


q_val=[1;1;1]; qdot_val=[1;1;1];qddot_val=[1;1;1];
c=0.5;

test=testFn([c.*L,L;0,1.*c],q_val,qdot_val,qddot_val,L);
phi_test=phi([c.*L,L;0,1.*c],q_val,qdot_val,qddot_val,L);
phi_dq([c.*L],q_val);
dq_test=phi_dq([c.*L,L],q_val);

debug_helper_out=x_dq_helper([c.*L,L,0],q_val,qdot_val,qddot_val);

for i=1:10000
custom_numerical_integrator_2fn_legacySlow(x_dq_helper,phi2,q_val,qdot_val,qddot_val,c.*L);
custom_numerical_integrator_2fn(x_dq_helper,phi2,q_val,qdot_val,qddot_val,c.*L);
end

