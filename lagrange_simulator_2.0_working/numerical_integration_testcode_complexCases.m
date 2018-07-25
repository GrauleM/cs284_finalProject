%TEST CODE FOR CUSTOM NUMERICAL INTEGRATION
phi     =@(s,q,qdot,qddot,L)     q(1).*s./L+q(2).*(s.^2./L.^2-s./L)+q(3).*(2.*s.^3./L.^3-3.*s.^2./L^2+s./L);
phidot  =@(s,q,qdot,qddot,L)  qdot(1).*s./L+qdot(2).*(s.^2./L.^2-s./L)+qdot(3).*(2.*s.^3./L.^3-3.*s.^2./L^2+s./L);

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


q_val=[1;1;1]; qdot_val=0;qddot_val=0;
c=0.5;
L=1;

% test=testFn([c.*L,L;0,1.*c],q_val,qdot_val,qddot_val,L)
% phi_test=phi([c.*L,L;0,1.*c],q_val,qdot_val,qddot_val,L)
% phi_dq([c.*L],q_val)
% phi_dq([c.*L,L;0,1.*c],q_val)

%debug_helper_out=x_dq_helper([c.*L,L;0,1.*c],q_val,qdot_val,qddot_val)

custom_numerical_integrator_1fn_legacySlow(x_dq_helper,q_val,qdot_val,qddot_val,c.*L)
custom_numerical_integrator_1fn(x_dq_helper,q_val,qdot_val,qddot_val,c.*L)