% manipulator simulator including inertia

% clear up
clear all; close all;

% L = const
% q = [alpha1,alpha2,alpha3, L] = [a1,a2,a3,L]
% split into 3 segments of identical length for inertia

% derivatives in time of alpha_i : ai_dt (velocities) and ai_dtt (accelerations)
% phi as a function of s

L=1;

E=1; %xx careful, change to realistic numbers
I=1;


%number of subsegments for center of mass computation
N=4;
%masses of segments
M=[1,1,1,1];

% syms a1 a2 a3
% syms a1_dt a2_dt a3_dt 
% syms a1_dtt a2_dtt a3_dtt 

a1=0; a2=0; a3=0;
a1_dt=0; a2_dt=0; a3_dt=0; 
a1_dtt=0; a2_dtt=0; a3_dtt =0;

syms s s_hat


% derivatives in time of alpha_i : ai_dt (velocities) and ai_dtt (accelerations)
% phi as a function of s
phi_s = a1./L.*s+a2./L.*(s.^2./L-s)+a3./L.*(2.*s.^3./L.^2-3.*s.^2./L+s);


% 1st derivative of phi with respect to time as fn of ai_dt
phi_dt_s = a1_dt./L.*s+a2_dt./L.*(s.^2./L-s)+a3_dt./L.*(2.*s.^3./L.^2-3.*s.^2./L+s);

% 2nd derivative of phi with respect to time as fn of ai_dtt
phi_dtt_s = a1_dtt./L.*s+a2_dtt./L.*(s.^2./L-s)+a3_dtt./L.*(2.*s.^3./L.^2-3.*s.^2./L+s);

%coefficients of ai in phi
coeff1=1./L.*s;
coeff2=1./L.*(s.^2./L-s);
coeff3=1./L.*(2.*s.^3./L.^2-3.*s.^2./L+s);

% x/y coordinate of point on backbone as a function of s
x_s = int(cos(phi_s),s,[0,s_hat]);
y_s = int(sin(phi_s),s,[0,s_hat]);

%note: how to evaluate an integral of x_s
int_xs=int(x_s,s_hat,[0,1])
numerical_value= vpa(int_xs)
%note end

% 1st order time derivative of these
x_dt_s = int(-sin(phi_s).*phi_dt_s,s,[0,s_hat]);
y_dt_s = int(cos(phi_s).*phi_dt_s,s,[0,s_hat]);


% 2nd order time derivatives of these: x_dtt_s and y_dtt_s
x_dtt_s = int(-cos(phi_s).*phi_dt_s^2-sin(phi_s).*phi_dtt_s,s,[0,s_hat]);
y_dtt_s = int(-sin(phi_s).*phi_dt_s^2+cos(phi_s).*phi_dtt_s,s,[0,s_hat]);



% derivatives of x_dt_s with respect to ai_dt
x_dt_da1dt_s = int(-1.*sin(phi_s).*coeff1,s,[0,s_hat]);
x_dt_da2dt_s = int(-1.*sin(phi_s).*coeff2,s,[0,s_hat]);
x_dt_da3dt_s = int(-1.*sin(phi_s).*coeff3,s,[0,s_hat]);

% derivatives of y_dt_s with respect to ai_dt
y_dt_da1dt_s = int(cos(phi_s).*coeff1,s,[0,s_hat]);
y_dt_da2dt_s = int(cos(phi_s).*coeff2,s,[0,s_hat]);
y_dt_da3dt_s = int(cos(phi_s).*coeff3,s,[0,s_hat]);


% derivatives of x_dt_s with respect to ai
x_dt_da1_s = int(-1.*cos(phi_s).*phi_dt_s.*coeff1,s,[0,s_hat]);
x_dt_da2_s = int(-1.*cos(phi_s).*phi_dt_s.*coeff2,s,[0,s_hat]);
x_dt_da3_s = int(-1.*cos(phi_s).*phi_dt_s.*coeff3,s,[0,s_hat]);

% derivatives of y_dt_s with respect to ai (need to confirm this one
% analytically)
y_dt_da1_s = int(-1.*sin(phi_s).*phi_dt_s.*coeff1,s,[0,s_hat]);
y_dt_da2_s = int(-1.*sin(phi_s).*phi_dt_s.*coeff2,s,[0,s_hat]);
y_dt_da3_s = int(-1.*sin(phi_s).*phi_dt_s.*coeff3,s,[0,s_hat]);



% derivatives of x_dtt_s with respect to ai_dt
x_dtt_da1dt_s = int(-2.*cos(phi_s).*phi_dt_s.*coeff1,s,[0,s_hat]);
x_dtt_da2dt_s = int(-2.*cos(phi_s).*phi_dt_s.*coeff2,s,[0,s_hat]);
x_dtt_da3dt_s = int(-2.*cos(phi_s).*phi_dt_s.*coeff3,s,[0,s_hat]);

% derivatives of y_dtt_s with respect to ai_dt
y_dtt_da1dt_s = int(-2.*sin(phi_s).*phi_dt_s.*coeff1,s,[0,s_hat]);
y_dtt_da2dt_s = int(-2.*sin(phi_s).*phi_dt_s.*coeff2,s,[0,s_hat]);
y_dtt_da3dt_s = int(-2.*sin(phi_s).*phi_dt_s.*coeff3,s,[0,s_hat]);


%center of mass (COM) of each sub-segment (N=4 total)

x_cmi=zeros(N,1);
y_cmi=zeros(N,1);
x_cmi_dt=zeros(N,1);
y_cmi_dt=zeros(N,1);
x_cmi_dtt=zeros(N,1);
y_cmi_dtt=zeros(N,1);

% derivatives of COM velocities with respect to ai
x_cmi_dt_da1=zeros(N,1); x_cmi_dt_da2=zeros(N,1); x_cmi_dt_da3=zeros(N,1);
y_cmi_dt_da1=zeros(N,1); y_cmi_dt_da2=zeros(N,1);y_cmi_dt_da3 =zeros(N,1);

% derivatives of COM velocities with respect to ai_dt
x_cmi_dt_da1dt=zeros(N,1); x_cmi_dt_da2dt=zeros(N,1); x_cmi_dt_da3dt=zeros(N,1);
y_cmi_dt_da1dt=zeros(N,1); y_cmi_dt_da2dt=zeros(N,1); y_cmi_dt_da3dt=zeros(N,1);

% derivatives of COM accelerations with respect to ai_dt
x_cmi_dtt_da1dt=zeros(N,1); x_cmi_dtt_da2dt=zeros(N,1); x_cmi_dtt_da3dt=zeros(N,1);
y_cmi_dtt_da1dt=zeros(N,1); y_cmi_dtt_da2dt=zeros(N,1); y_cmi_dtt_da3dt=zeros(N,1);


%xx todo: rewrite more efficiently (using matrices)
for i=1:N
    
    % COM positions
    x_cmi(i)=1./(L./N).*int(x_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);
    y_cmi(i)=1./(L./N).*int(y_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);
    
    % COM velocities
    x_cmi_dt(i)=1./(L./N).*int(x_dt_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);
    y_cmi_dt(i)=1./(L./N).*int(y_dt_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);
    
    % COM accelerations
    x_cmi_dtt(i)=1./(L./N).*int(x_dtt_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);
    y_cmi_dtt(i)=1./(L./N).*int(y_dtt_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);
    
    
    % derivatives of COM velocities with respect to ai
    x_cmi_dt_da1(i)=1./(L./N).*int(x_dt_da1_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);
	x_cmi_dt_da2(i)=1./(L./N).*int(x_dt_da2_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);
    x_cmi_dt_da3(i)=1./(L./N).*int(x_dt_da3_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);

    y_cmi_dt_da1(i)=1./(L./N).*int(y_dt_da1_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);
	y_cmi_dt_da2(i)=1./(L./N).*int(y_dt_da2_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);
    y_cmi_dt_da3(i)=1./(L./N).*int(y_dt_da3_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);

    % derivatives of COM velocities with respect to ai_dt
    x_cmi_dt_da1dt(i)=1./(L./N).*int(x_dt_da1dt_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);
	x_cmi_dt_da2dt(i)=1./(L./N).*int(x_dt_da2dt_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);
    x_cmi_dt_da3dt(i)=1./(L./N).*int(x_dt_da3dt_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);

    y_cmi_dt_da1dt(i)=1./(L./N).*int(y_dt_da1dt_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);
	y_cmi_dt_da2dt(i)=1./(L./N).*int(y_dt_da2dt_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);
    y_cmi_dt_da3dt(i)=1./(L./N).*int(y_dt_da3dt_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);

    % derivatives of COM accelerations with respect to ai_dt
    x_cmi_dtt_da1dt(i)=1./(L./N).*int(x_dtt_da1dt_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);
	x_cmi_dtt_da2dt(i)=1./(L./N).*int(x_dtt_da2dt_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);
    x_cmi_dtt_da3dt(i)=1./(L./N).*int(x_dtt_da3dt_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);

    y_cmi_dtt_da1dt(i)=1./(L./N).*int(y_dtt_da1dt_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);
	y_cmi_dtt_da2dt(i)=1./(L./N).*int(y_dtt_da2dt_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);
    y_cmi_dtt_da3dt(i)=1./(L./N).*int(y_dtt_da3dt_s,s_hat,[(i-1).*(L./N),i.*(L./N)]);

    
end

%visualization check
q=[a1,a2,a3,L];
h1=figure(1);
hold on;
axis equal;
visualize_q(q,L,h1,[0,0,0],'-')
plot(x_cmi,y_cmi,'r*')

%compute kinetic energy derivatives with respect to time and ai_dt
%(generalized velocities)

%xx dont forget multiplication with M / m_i
T_kin_dt_da1dt=0;
T_kin_dt_da2dt=0;
T_kin_dt_da3dt=0;

T_kin_da1=0;
T_kin_da2=0;
T_kin_da3=0;



for i=1:N
    
    summand1=M(i).*...
        ((x_cmi_dtt(i)+y_cmi_dtt(i))*(x_cmi_dt_da1dt(i)+y_cmi_dt_da1dt(i))...
        +(x_cmi_dt(i)+y_cmi_dt(i))*(x_cmi_dtt_da1dt(i)+y_cmi_dtt_da1dt(i)));
    
    summand2=M(i).*...
        ((x_cmi_dtt(i)+y_cmi_dtt(i))*(x_cmi_dt_da2dt(i)+y_cmi_dt_da2dt(i))...
        +(x_cmi_dt(i)+y_cmi_dt(i))*(x_cmi_dtt_da2dt(i)+y_cmi_dtt_da2dt(i)));
    
    summand3=M(i).*...
        ((x_cmi_dtt(i)+y_cmi_dtt(i))*(x_cmi_dt_da3dt(i)+y_cmi_dt_da3dt(i))...
        +(x_cmi_dt(i)+y_cmi_dt(i))*(x_cmi_dtt_da3dt(i)+y_cmi_dtt_da3dt(i)));
    
    
    T_kin_dt_da1dt=T_kin_dt_da1dt+summand1;
    T_kin_dt_da2dt=T_kin_dt_da1dt+summand2;
    T_kin_dt_da3dt=T_kin_dt_da1dt+summand3;

    
    summand4=M(i).*...
        (x_cmi_dt(i)+y_cmi_dt(i))*(x_cmi_dt_da1(i)+y_cmi_dt_da1(i));
    
    summand5=M(i).*...
        (x_cmi_dt(i)+y_cmi_dt(i))*(x_cmi_dt_da2(i)+y_cmi_dt_da2(i));
    
    summand6=M(i).*...
        (x_cmi_dt(i)+y_cmi_dt(i))*(x_cmi_dt_da3(i)+y_cmi_dt_da3(i));
    
    T_kin_da1=T_kin_da1+summand4;
    T_kin_da2=T_kin_da2+summand5;
    T_kin_da3=T_kin_da3+summand6;
    
end

%equations of motion (line by line for q_i)

Ma=0;
line1=T_kin_dt_da1dt-(T_kin_da1-a1.*E.*I./L)+Ma; %xx this ignores contact forces; also verify tip moment Ma
line2=T_kin_dt_da2dt-(T_kin_da2-a2.*E.*I./(3.*L));
line3=T_kin_dt_da3dt-(T_kin_da3-a3.*E.*I./(5.*L));

