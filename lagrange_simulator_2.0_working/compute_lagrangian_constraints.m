function ceq=compute_lagrangian_constraints(forces,q_val,qdot_val,qddot_val,params)

%note: functions are defined as functions of the variables q,qdot,qddot.
%the functions need to be evaluated at the given 'values' for these
%variables, which are passed into the function as q_val,qdot_val,qddot_val

% reminder: params is defined as follows: 
%   params=[ d,L0,E,I,Aeff,rho_line,g,b1,b2,b3]; 
L=params(2);
E=params(3);
I=params(4);
rho=params(6); %xx consider to make this rho per area along the line. if so, remember changing the functions below
g=params(7);

b1=params(8);
b2=params(9);
b3=params(10);

% for debugging xx remove
% q_val=[1;1;1];
% qdot_val=[0;1;0];
% qddot_val=[1;0;0];

% the vector 'forces' contains the tip moment Ma, the N contact force
% magnitudes, and the N contact points as follows:
% forces=[Ma,Fc_mag1,...,Fc_magN,c_point1,...c_pointN]
Ma=forces(1); %tip moment Ma

if length(forces)<2
    disp("ERROR: specify at least one pair of contact force and contact point. specify F_c=0 if no contact force is desired")
else
    N_contact= (length(forces)-1)/2; %number of contact forces 
    Fc_mags=forces(2:N_contact+1); %contact force magnitudes 
    c_points=forces(N_contact+2:end); %contact points
end

% xx note on efficiency: it may be a waste of time to define all these
% functions as 'anonymous functions' every time this code is executed. may
% be better to define them in their own files to be always available.


%phi(s),phidot(s) and phiddot(s)
%phi     =@(s,q)     q(1)*s/L+q(2)*(s^2/L^2-s/L)+q(3)*(2*s^3/L^3-3*s^2/L^2+s/L);
phidot  =@(s,qdot)  qdot(1).*s./L+qdot(2).*(s.^2./L.^2-s./L)+qdot(3).*(2.*s.^3./L.^3-3.*s.^2./L^2+s./L);
phiddot =@(s,qddot) qddot(1).*s./L+qddot(2).*(s.^2./L.^2-s./L)+qddot(3).*(2.*s.^3./L.^3-3.*s.^2./L.^2+s./L);

%derivatives of phi,phidot and phiddot with respect to q,qdot,qddot
phi_dq=@(s,q)               [s./L;...
                             (s.^2./L.^2-s./L);...
                             (2.*s.^3./L.^3-3.*s.^2./L.^2+s./L)];
phidot_dqdot=@(s,qdot)      [s./L;...
                             (s.^2./L.^2-s./L);...
                             (2.*s.^3./L.^3-3.*s.^2./L.^2+s./L)];
phiddot_dqddot=@(s,qddot)   [s./L;...
                             (s.^2./L.^2-s./L);...
                             (2.*s.^3./L.^3-3.*s.^2./L.^2+s./L)];

% various integration helper functions
% these functions need to be integrated from 0 to s to get x(s) and y(s)        
x_helper=@(s,q,qdot,qddot)          cos(phi(s,q,qdot,qddot,L));
y_helper=@(s,q,qdot,qddot)          sin(phi(s,q,qdot,qddot,L));
% this function needs to be integrated from 0 to s to get dx(s)/dq and dy(s)/dq        
x_dq_helper=@(s,q,qdot,qddot)       -sin(phi(s,q,qdot,qddot,L)).*phi_dq(s,q);   
y_dq_helper=@(s,q,qdot,qddot)       cos(phi(s,q,qdot,qddot,L)).*phi_dq(s,q);   
% these functions need to be integrated from 0 to s to get xdot(s) and ydot(s)        
xdot_helper=@(s,q,qdot,qddot)       -sin(phi(s,q,qdot,qddot,L)).*phidot(s,qdot);
ydot_helper=@(s,q,qdot,qddot)       cos(phi(s,q,qdot,qddot,L)).*phidot(s,qdot);  
% these functions need to be integrated from 0 to s to get xddot(s) and yddot(s)        
xddot_helper=@(s,q,qdot,qddot)      -cos(phi(s,q,qdot,qddot,L)).*phidot(s,qdot).^2-sin(phi(s,q,qdot,qddot,L)).*phiddot(s,qddot);
yddot_helper=@(s,q,qdot,qddot)      -sin(phi(s,q,qdot,qddot,L)).*phidot(s,qdot).^2+cos(phi(s,q,qdot,qddot,L)).*phiddot(s,qddot);
% these functions need to be integrated from 0 to s to get dxdot(s)/dq and dydot(s)/dq        
xdot_dq_helper=@(s,q,qdot,qddot)    -cos(phi(s,q,qdot,qddot,L)).*phidot(s,qdot).*phi_dq(s,q);   
ydot_dq_helper=@(s,q,qdot,qddot)    -sin(phi(s,q,qdot,qddot,L)).*phidot(s,qdot).*phi_dq(s,q);   
% these functions need to be integrated from 0 to s to get dxdot(s)/dqdot and dydot(s)/dqdot        
xdot_dqdot_helper=@(s,q,qdot,qddot) sin(phi(s,q,qdot,qddot,L)).*phidot_dqdot(s,qdot);
ydot_dqdot_helper=@(s,q,qdot,qddot) cos(phi(s,q,qdot,qddot,L)).*phidot_dqdot(s,qdot);
% these functions need to be integrated from 0 to s to get dxddot(s)/dqdot and dyddot(s)/dqdot        
xddot_dqdot_helper=@(s,q,qdot,qddot) -2*cos(phi(s,q,qdot,qddot,L)).*phidot(s,qdot).*phidot_dqdot(s,qdot);
yddot_dqdot_helper=@(s,q,qdot,qddot) -2*sin(phi(s,q,qdot,qddot,L)).*phidot(s,qdot).*phidot_dqdot(s,qdot);


%Derivatives of Vc with respect to q
Vc_dq=@(q,qdot,qddot) E.*I./L.*[q(1);...
                            q(2)./3;...
                            q(3)./5];

%Derivatives of Tkin with respect to q
Tkin_dq=@(q,qdot,qddot) ...
    rho.*...
       custom_numerical_integrator_2fn(...   %first term in integral
           xdot_helper,...
           xdot_dq_helper,...
           q,qdot,qddot,L)...
    +...
    rho.*... %second term in integral
        custom_numerical_integrator_2fn(...
           ydot_helper,...
           ydot_dq_helper,...
           q,qdot,qddot,L)...
     ;

% %Derivatives of Tkin with respect to qdot  %xx this may not be needed -
% %xx remove?
% Tkin_dqdot=@(q,qdot,qddot) ...
%     rho.*...
%        custom_numerical_integrator_2fn(...   %first term in integral
%            xdot_helper,...
%            xdot_dqdot_helper,...
%            q,qdot,qddot,L)...
%     +...
%     rho.*... %second term in integral
%         custom_numerical_integrator_2fn(...
%            ydot_helper,...
%            ydot_dqdot_helper,...
%            q,qdot,qddot,L)...
%     ;

% d/dt (Derivatives of Tkin with respect to qdot)
% (time derivative of the derivatives of Tkin with respect to qdot)
Tkin_dqdot_dt=@(q,qdot,qddot) ...
    rho.*...
       custom_numerical_integrator_2fn(...   %first term in integral
           xddot_helper,...
           xdot_dqdot_helper,...
           q,qdot,qddot,L)...
    +...
    rho.*... %second term in integral
        custom_numerical_integrator_2fn(...
           xdot_helper,...
           xddot_dqdot_helper,...
           q,qdot,qddot,L)...    
    +...
    rho.*... %3rd term in integral
        custom_numerical_integrator_2fn(...
           yddot_helper,...
           ydot_dqdot_helper,...
           q,qdot,qddot,L)...    
    +...
    rho.*... %4th term in integral
        custom_numerical_integrator_2fn(...
           ydot_helper,...
           yddot_dqdot_helper,...
           q,qdot,qddot,L)...
    ;
       
%Derivatives of Vg with respect to q
Vg_dq=@(q,qdot,qddot) ...
    g.*rho.*...
    custom_numerical_integrator_1fn(...
           y_dq_helper,...
           q,qdot,qddot,L)...
    ;     

% include external contact forces (using Jacobian to map them to
% generalized coordinates)

% J_sc: jacobian associated with point at arch length sc (sc: s_contact)
% c ranges from 0 to 1; sc=c*L
J_sc_transpose=@(c,L,q,qdot,qddot) ...
               [ custom_numerical_integrator_1fn(x_dq_helper,q,qdot,qddot,c.*L),...
                 custom_numerical_integrator_1fn(y_dq_helper,q,qdot,qddot,c.*L)];

% directional contact forces (xx important: this assumes contact forces are
% normal to the backbone!)
% at contact point defined by sc
Fc_direction_sc =@(c,q,qdot,qddot,L) [...
        sin(phi(c.*L,q,qdot,qddot,L));...
        -cos(phi(c.*L,q,qdot,qddot,L))];
    
% sum accross all contact forces xx VECTORIZE MEEE xx
generalized_extForces_sum=0;
for ii=1:length(c_points)
        c=c_points(ii);
        generalized_extForces_sum=generalized_extForces_sum+Fc_mags(ii).*J_sc_transpose(c,L,q_val,qdot_val,qddot_val)*Fc_direction_sc(c,q_val,qdot_val,qddot_val,L);
end

%Lagrangian constraints
%moments (has to be equal to 0)


ceq_lagrangian=@(q,qdot,qddot) ...    %note: this function definition step can be skipped
      Tkin_dqdot_dt(q,qdot,qddot)...
    - Tkin_dq(q,qdot,qddot)...
    + Vc_dq(q,qdot,qddot)...
    + Vg_dq(q,qdot,qddot)...
    + [Ma;0;0]...                  %add effect of actuator moment at the tip
    + generalized_extForces_sum...   %add contribution of external forces
    + [b1;b2;b3].*qdot;              %add effect of damping xx care, verify


ceq=ceq_lagrangian(q_val,qdot_val,qddot_val);

end