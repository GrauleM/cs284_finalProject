function [c,ceq,DC,DCeq] = constraints_v6(x,params,obst)

    % this version of the constraint function includes constraints on physicality (equilibrium)
    % only
    
    %this version treats the computation of L differently: L is directly
    %computed from steady state solution given actuator forces. then no
    %external actuator forces are applied
    
    
    % this version only allows for 1 contact force; the other contact forces Fc2, Fc3
    % are forced to zero through constraints
    
    % x = [Na1,Na2,Fc1,Fc2,Fc3,c1,c2,c3,alpha1,alpha2,alpha3,L,comp_slack]
    
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
    comp_slack=x(13);

    %[a1,a2,a3,L]=q(1,1:4);
    c_vec=x(6:8);
    Fc_vec=x(3:5);
    Na=x(1)+x(2);
    Ma=d*(x(2)-x(1));
    
    % useful functions
    %note: s from 0 to L
    phi_s = @(s) q(1)./q(4).*s+q(2)./q(4).*(s.^2./q(4)-s)+q(3)./q(4).*(2.*s.^3./q(4).^2-3.*s.^2./q(4)+s); %CHECKED
    
    %integrand for gradients of xc and yc with respect to elements of q as functions of s
    f1_s=@(s) -sin(phi_s(s)).* s./L;
    f2_s=@(s) -sin(phi_s(s)).* s.^2./L.^2-s./L;
    f3_s=@(s) -sin(phi_s(s)).* 2.*s.^3/L.^3-s.^2./L.^2+s./L;
    
    f5_s=@(s) cos(phi_s(s)).* s./L;
    f6_s=@(s) cos(phi_s(s)).* s.^2./L.^2-s./L;
    f7_s=@(s) cos(phi_s(s)).* 2.*s.^3./L.^3-s.^2./L.^2+s./L;
    
    % function to compute the jacobian at contact point c (c between 0 and
    % 1)
    Jc_c =@(c) ... 
        [integral(f1_s,0,c.*L),...
        integral(f2_s,0,c.*L),...
        integral(f3_s,0,c.*L);...
        integral(f5_s,0,c.*L),...
        integral(f6_s,0,c.*L),...
        integral(f7_s,0,c.*L)...
        ];
    
    %direction of contact force at contact point defined by c
    Fc_c =@(c) [...
        sin(phi_s(c.*L));...
        -cos(phi_s(c.*L))];
    
    %derivatives of the lagrange term
    dLda1=-a1*E*I/L;%dL/dalpha1
    dLda2=-a2*E*I/(3*L);%dL/dalpha2
    dLda3=-a3*E*I/(5*L);%dL/dalpha3
    
    Jc_sum=zeros(3,1);

    %for each external force, compute the generalized force (w jacobian)
    %and add it to the constraint function (g_e(q) in report)
    for ii=1:length(c_vec)
        Jc_sum=Jc_sum+Fc_vec(ii)*Jc_c(c_vec(ii).*L)'*Fc_c(c_vec(ii).*L);
    end

    %constraints for equilibrium
    c5=dLda1+Jc_sum(1,:)+Ma;%add the tip moment  
    c6=dLda2+Jc_sum(2,:);
    c7=dLda3+Jc_sum(3,:);
    
    final_pos_equalityConstraints=[];
   
    physical_sln_equalityConstraints=...
        [c5,...
        c6,...
        c7...
        ];
   
    %distance between contact point 1 and obstacle boundary has to be zero
    cos_phi_s =@(s) cos(phi_s(s));  
    sin_phi_s =@(s) sin(phi_s(s));  
    
    %define a function that computes the distance between the obstacle
    %boundary and a point on the manipulator (defined by s, where s goes
    %from 0 to L)
    dist_fn=@(s) -((integral(cos_phi_s,0,s.*q(4))-obst(1)).^2+(integral(sin_phi_s,0,s.*q(4))-obst(2)).^2)^.5+obst(3);
    
    xc = integral(cos_phi_s,0,c_vec(1).*q(4)); %position of contact point
    yc = integral(sin_phi_s,0,c_vec(1).*q(4));
    
    dist_to_obst=((obst(1)-xc).^2+(obst(2)-yc).^2).^0.5;
    
    c_cont_obstDist=-(dist_to_obst-obst(3)); %for contact point, distance to obstacle has to be larger than obstacle radius r_o, or: -(dist)+r<=0
    
    c_complementary=c_cont_obstDist*x(3)-comp_slack; %forces can only occur when contact with obstacle is given; c_comp has to be zero
    
    %contact forces have to point in opposite direction of the vector from
    %obst center to contact point
    c_force_direction=-([xc,yc]-[obst(1),obst(2)])*Fc_c(c_vec(1).*L)*sign(Fc_vec(1));
    
    s_obst_check=0:0.05:1;
    c_obstDist=zeros(size(s_obst_check));
    for j=1:length(s_obst_check)
        c_obstDist(j)=dist_fn(s_obst_check(j)); %other points on the manipulator also have to be outside the obstacle - check this for a bunch of points
    end
    
    %add one more constraint saying that contact forces have to be positive
    
    % Inequality constraints
    c=[-x(6),... %ensuring that the contact point is on the manipulator
        x(6)-1,...%ensuring that the contact point is on the manipulator
        -x(7),...%ensuring that the contact point is on the manipulator
        x(7)-1,...%ensuring that the contact point is on the manipulator
        -x(8),...%ensuring that the contact point is on the manipulator
        x(8)-1,...%ensuring that the contact point is on the manipulator
        c_cont_obstDist, ...
        0.01*c_obstDist, ...
        c_force_direction,...
        -comp_slack ...
        %c_force_positive
        ];
    
    % constraints to force FC2,2 and c2,3 to be zero
    zero_Fc_constraints=[x(4),x(5),x(7),x(8)];

    %length constraint:
    c_length=L-L0-Na./(Aeff.*E);
    
    % Nonlinear equality constraints
    ceq=multiplication_factor.*[final_pos_equalityConstraints,...
        phys_sln_multFactor.*physical_sln_equalityConstraints,...
        zero_Fc_constraints, ...
        c_complementary,...
        c_length
    ];
    

end