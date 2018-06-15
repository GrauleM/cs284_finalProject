% manipulator simulator including inertia

% L = const
% q = [alpha1,alpha2,alpha3, L] = [a1,a2,a3,L]
% split into 3 segments of identical length for inertia

% derivatives in time of alpha_i : ai_dt (velocities) and ai_dtt (accelerations)
% phi as a function of s
phi_s = @(s) a1./L.*s+a2./L.*(s.^2./L-s)+a3./L.*(2.*s.^3./L.^2-3.*s.^2./L+s);

% 1st derivative of phi with respect to time as fn of ai_dt
phi_dt_s = @(s) a1_dt./L.*s+a2_dt./L.*(s.^2./L-s)+a3_dt./L.*(2.*s.^3./L.^2-3.*s.^2./L+s);

% 2nd derivative of phi with respect to time as fn of ai_dtt
phi_dtt_s = @(s) a1_dtt./L.*s+a2_dtt./L.*(s.^2./L-s)+a3_dtt./L.*(2.*s.^3./L.^2-3.*s.^2./L+s);

%coefficients of ai in phi
coeff1=1./L.*s;
coeff2=1./L.*(s.^2./L-s);
coeff3=1./L.*(2.*s.^3./L.^2-3.*s.^2./L+s);

   
% x/y coordinate of point on backbone as a function of s
x_s = @(s) integral(cos(phi_s(s)),0,s);
y_s = @(s) integral(sin(phi_s(s)),0,s);

% 1st order time derivative of these
x_dt_s = @(s) integral(-sin(phi_s(s)).*phi_dt_s,0,s);
y_dt_s = @(s) integral(cos(phi_s(s)).*phi_dt_s,0,s);

% 2nd order time derivatives of these: x_dtt_s and y_dtt_s
% xx to do if needed

% derivatives of x_dt_s with respect to ai_dt
x_dt_da1dt_s = @(s) integral(-1.*sin(phi_s(s)).*coeff1,0,s);
x_dt_da2dt_s = @(s) integral(-1.*sin(phi_s(s)).*coeff2,0,s);
x_dt_da3dt_s = @(s) integral(-1.*sin(phi_s(s)).*coeff3,0,s);

% derivatives of y_dt_s with respect to ai_dt
y_dt_da1dt_s = @(s) integral(cos(phi_s(s)).*coeff1,0,s);
y_dt_da2dt_s = @(s) integral(cos(phi_s(s)).*coeff2,0,s);
y_dt_da3dt_s = @(s) integral(cos(phi_s(s)).*coeff3,0,s);


% derivatives of x_dt_s with respect to ai
x_dt_da1_s = @(s) integral(-1.*cos(phi_s(s)).*phi_dt_s.*coeff1,0,s);
x_dt_da2_s = @(s) integral(-1.*cos(phi_s(s)).*phi_dt_s.*coeff2,0,s);
x_dt_da3_s = @(s) integral(-1.*cos(phi_s(s)).*phi_dt_s.*coeff3,0,s);

% derivatives of y_dt_s with respect to ai (need to confirm this one
% analytically)
y_dt_da1_s = @(s) integral(-1.*sin(phi_s(s)).*phi_dt_s.*coeff1,0,s);
y_dt_da2_s = @(s) integral(-1.*sin(phi_s(s)).*phi_dt_s.*coeff2,0,s);
y_dt_da3_s = @(s) integral(-1.*sin(phi_s(s)).*phi_dt_s.*coeff3,0,s);



% derivatives of x_dtt_s with respect to ai_dt
x_dtt_da1dt_s = @(s) integral(-2.*cos(phi_s(s)).*phi_dt_s.*coeff1,0,s);
x_dtt_da2dt_s = @(s) integral(-2.*cos(phi_s(s)).*phi_dt_s.*coeff2,0,s);
x_dtt_da3dt_s = @(s) integral(-2.*cos(phi_s(s)).*phi_dt_s.*coeff3,0,s);

% derivatives of y_dtt_s with respect to ai_dt
y_dtt_da1dt_s = @(s) integral(-2.*sin(phi_s(s)).*phi_dt_s.*coeff1,0,s);
y_dtt_da2dt_s = @(s) integral(-2.*sin(phi_s(s)).*phi_dt_s.*coeff2,0,s);
y_dtt_da3dt_s = @(s) integral(-2.*sin(phi_s(s)).*phi_dt_s.*coeff3,0,s);

