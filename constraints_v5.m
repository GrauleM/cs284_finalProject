function [c,ceq,DC,DCeq] = constraints_v4(x,params,obst)

    % this version of the constraint function includes constraints on physicality (equilibrium)
    % only
    
    % only allows for 1 contact force
    
    % x = [Na1,Na2,Fc1,Fc2,Fc3,c1,c2,c3,alpha1,alpha2,alpha3,L]
    
    multiplication_factor=params(1);
    phys_sln_multFactor=params(2);
    d=params(3); %distance from center (spine) to middle of actuator

    L0=params(4); %1cm
    E=params(5); %the Youngs modulus of silicone rubber is 0.05GPa
    I=params(6);
    Aeff=params(7);
    
    % desired actuator state
    q=x(9:12);
    a1=q(1);
    a2=q(2);
    a3=q(3);
    L=q(4);
    

    %[a1,a2,a3,L]=q(1,1:4);
    c_vec=x(6:8);
    Fc_vec=x(3:5);
    Na=x(1)+x(2);
    Ma=d*(x(2)-x(1));
    
    % useful functions
    %note: s from 0 to L
    phi_s = @(s) q(1)./q(4).*s+q(2)./q(4).*(s.^2./q(4)-s)+q(3)./q(4).*(2.*s.^3./q(4).^2-3.*s.^2./q(4)+s); %CHECKED
    
    dphidalpha1_s = @(s) s./L; %CHECKED
    dphidalpha2_s = @(s) s^2./L^2-s/L;  %CHECKED
    dphidalpha3_s = @(s) 2*s^3/L^3-3.*s^2./L^2+s/L; %FIXED
    dphidL_s = @(s) -s./L^2*(a1-a2+a3)-2*s^2/L^3*(a2-3*a3)-6*s^3/L^4*a3; %CHECKED
    
    %integrand for gradients of xc and yc with respect to elements of q as functions of s
    f1_s=@(s) -sin(phi_s(s)).* s./L;
    f2_s=@(s) -sin(phi_s(s)).* s.^2./L.^2-s./L;
    f3_s=@(s) -sin(phi_s(s)).* 2.*s.^3/L.^3-s.^2./L.^2+s./L;
    f4_s=@(s) -sin(phi_s(s)).* -s./L.^2.*(a1-a2+a3)-2.*s.^2./L.^3.*(a2-3*a3)-6.*s.^3./L.^4.*a3;
    
    f5_s=@(s) cos(phi_s(s)).* s./L;
    f6_s=@(s) cos(phi_s(s)).* s.^2./L.^2-s./L;
    f7_s=@(s) cos(phi_s(s)).* 2.*s.^3./L.^3-s.^2./L.^2+s./L;
    f8_s=@(s) cos(phi_s(s)).* -s./L.^2.*(a1-a2+a3)-2.*s.^2./L^3*(a2-3*a3)-6.*s.^3./L.^4.*a3;
    
    
    Jc_c =@(c) ...
        [integral(f1_s,0,c.*L),...
        integral(f2_s,0,c.*L),...
        integral(f3_s,0,c.*L),...
        cos(phi_s(c*L))*c+integral(f4_s,0,c.*L);...
        integral(f5_s,0,c.*L),...
        integral(f6_s,0,c.*L),...
        integral(f7_s,0,c.*L),...
        sin(phi_s(c.*L))*c+integral(f8_s,0,c.*L)...
        ];
    
    Fc_c =@(c) [...
        sin(phi_s(c.*L));...
        -cos(phi_s(c.*L))];
    
    % some helpers
    %derivatives of the lagrange
    dLda1=-a1*E*I/L;%dL/dalpha1
    dLda2=-a2*E*I/(3*L);%dL/dalpha2
    dLda3=-a3*E*I/(5*L);%dL/dalpha3
    dLdL=E*I/(2*L^2)*(a1^2+a2^2/3+a3^2/5)+Aeff.*E*(L0-L);
    
    Jc_sum=zeros(4,1);

    for ii=1:length(c_vec)
        
        Jc_sum=Jc_sum+Fc_vec(ii)*Jc_c(c_vec(ii).*L)'*Fc_c(c_vec(ii).*L);
    end
    %add the tip force
    Jc_sum=Jc_sum+Na*Jc_c(1.)'*[cos(phi_s(L));sin(phi_s(L))];
        
    c5=dLda1+Jc_sum(1,:)+Ma;
    c6=dLda2+Jc_sum(2,:);
    c7=dLda3+Jc_sum(3,:);
    c8=dLdL+Jc_sum(4,:);
    
    % Inequality constraints
    c=[-x(6),...
        x(6)-1,...
        -x(7),...
        x(7)-1,...
        -x(8),...
        x(8)-1,...
        ];
    
%     final_pos_equalityConstraints=...
%         [q_des(1)-q(1),...    %c1
%         q_des(2)-q(2),...      %c2
%         q_des(3)-q(3),...       %c3
%         q_des(4)-q(4)];
    final_pos_equalityConstraints=[];
   
    physical_sln_equalityConstraints=...
        [c5,...
        c6,...
        c7,...
        c8...
        ];
   
    %distance between contact point 1 and obstacle boundary has to be zero
    cos_phi_s =@(s) cos(phi_s(s));  
    sin_phi_s =@(s) sin(phi_s(s));  
    
    dist_fn=@(s) -((integral(cos_phi_s,0,s.*q(4))-obst(1)).^2+(integral(sin_phi_s,0,s.*q(4))-obst(2)).^2)^.5+obst(3);
    
    xc = integral(cos_phi_s,0,c_vec(1).*q(4)); %position of contact point
    yc = integral(sin_phi_s,0,c_vec(1).*q(4));
    
    dist_to_obst=((obst(1)-xc).^2+(obst(2)-yc).^2).^0.5;
    
    c_cont_obstDist=-(dist_to_obst-obst(3)); %for contact point, distance to obstacle has to be larger than obstacle radius r_o, or: -(dist)+r<=0
    
    c_complementary=0.01*c_cont_obstDist*x(3); %forces can only occur when contact with obstacle is given; c+comp has to be zero
    
    s_obst_check=0:0.05:1;
    c_obstDist=zeros(size(s_obst_check));
    for j=1:length(s_obst_check)
        c_obstDist(j)=dist_fn(s_obst_check(j)); %other points on the manipulator also have to be outside the obstacle - check a bunch of points
    end
    
    %add one more constraint saying that contact forces have to be positive
    
    % Inequality constraints
    c=[-x(6),...
        x(6)-1,...
        -x(7),...
        x(7)-1,...
        -x(8),...
        x(8)-1,...
        c_cont_obstDist, ...
        0.01*c_obstDist ...
        ];
    
    % constraints to force FC2,2 and c2,3 to be zero
    zero_Fc_constraints=[x(4),x(5),x(7),x(8)];

    
    % Nonlinear equality constraints
    ceq=multiplication_factor.*[final_pos_equalityConstraints,...
        phys_sln_multFactor.*physical_sln_equalityConstraints,...
        zero_Fc_constraints, ...
        c_complementary
    ];
    
    % Gradient of the constraints:
    if nargout > 2
        DC= [zeros(1,5),-1.,zeros(1,6);...
            zeros(1,5),1.,zeros(1,6);...
            zeros(1,6),-1.,zeros(1,5);...
            zeros(1,6),1.,zeros(1,5);...
            zeros(1,7),-1.,zeros(1,4);...
            zeros(1,7),1.,zeros(1,4)...
            ];
        DCeq = multiplication_factor.*[...
%             zeros(1,8), -1., zeros(1,3);... %dc1/dx(i)
%             zeros(1,9), -1.,zeros(1,2);... %dc2/dx(i)
%             zeros(1,10), -1., 0;... %dc3/dx(i)
%             zeros(1,11), -1.; ... %dc4/dx(i)
            ; ... %dc5/dx(i)
            ; ... %dc6/dx(i)
            ; ... %dc7/dx(i)
            ; ... %dc8/dx(i)            
            ];
    end


end