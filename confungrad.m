function [c,ceq,DC,DCeq] = confungrad(x)

    % x = [Na1,Na2,Fc1,Fc2,Fc3,c1,c2,c3,alpha1,alpha2,alpha3,L]
    
    E=1;
    I=1;
    L0=1;
    % desired actuator state
    q_des=[0,1,0,1];
    q=x(9:12);
    a1=q(1);
    a2=q(2);
    a3=q(3);
    L=q(4);


    %[a1,a2,a3,L]=q(1,1:4);
    c_vec=x(6:8);
    Fc_vec=x(3:5);
    Na=x(1)+x(2);
    d=0.05;
    Ma=d*(x(2)-x(1));
    
    % useful functions
    %note: s from 0 to L
    phi_s = @(s) q(1)./q(4).*s+q(2)./q(4).*(s.^2./q(4)-s)+q(3)./q(4).*(2.*s.^3./q(4).^2-3.*s.^2./q(4)+s);
    cos_phi_s =@(s) cos(q(1)./q(4).*s+q(2)./q(4).*(s.^2./q(4)-s)+q(3)./q(4).*(2.*s.^3./q(4).^2-3.*s.^2./q(4)+s));  
    sin_phi_s =@(s) sin(q(1)./q(4).*s+q(2)./q(4).*(s.^2./q(4)-s)+q(3)./q(4).*(2.*s.^3./q(4).^2-3.*s.^2./q(4)+s));  

    dphidalpha1_s = @(s) s./L;
    dphidalpha2_s = @(s) s^2./L^2-s/L;
    dphidalpha3_s = @(s) 2*s^3/L^3-s^2./L^2+s/L;
    dphidL_s = @(s) -s./L^2*(a1-a2+a3)-2*s^2/L^3*(a2-3*a3)-6*s^3/L^4*a3;
    
    Jc_c =@(c) ...
        [integral(-sin_phi_s*dphidalpha1_s,0,c.*L),...
        integral(-sin_phi_s*dphidalpha2_s,0,c.*L),...
        integral(-sin_phi_s*dphidalpha3_s,0,c.*L),...
        cos_phi_s(c*L)*c+integral(-sin_phi_s*dphidalpha1_s,0,c.*L);...
        integral(cos_phi_s*dphidalpha1_s,0,c.*L),...
        integral(cos_phi_s*dphidalpha1_s,0,c.*L),...
        integral(cos_phi_s*dphidalpha1_s,0,c.*L),...
        sin_phi_s(c*L)*c+integral(cos_phi_s*dphidalpha1_s,0,c.*L)...
        ];
    
    Fc_c =@(c) [...
        sin_phi_s(c*L);...
        -cos_phi_s(c*L)];
    
     % some helpers
    %derivatives of the lagrange
    dLda1=-a1*E*I/L;%dL/dalpha1
    dLda2=-a2*E*I/(3*L);%dL/dalpha2
    dLda3=-a3*E*I/(5*L);%dL/dalpha3
    dLdL=E*I/(2*L^2)*(a1^2+a2^2/3+a3^2/5)+(L0-L);
    
    Jc_sum=zeros(1,4);
    for ii=1:length(c_vec)
        
        Jc_sum=Jc_sum+Fc_vec(ii)*Jc_c(c_vec(ii)*L)'*Fc_c(c_vec(ii)*L);
        
    end
    %add the tip force
    Jc_sum=Jc_sum+Na*Jc_c(L)'*[cos_phi_s(L);sin_phi_s(L)];
        
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
    
    
   
    % Nonlinear equality constraints
    ceq=[q_des(1)-q(1),...    %c1
        q_des(2)-q(2),...      %c2
        q_des(3)-q(3),...       %c3
        q_des(4)-q(4),...       %c4
        c5,...
        c6,...
        c7,...
        c8...
    ];
    
    % Gradient of the constraints:
    if nargout > 2
        DC= [zeros(1,8), 1, zeros(1,3);... %dc1/dx(i)
            zeros(1,9), 1,zeros(1,2);... %dc2/dx(i)
            zeros(1,10), 1, 0;... %dc3/dx(i)
            zeros(1,11), 1;... %dc4/dx(i)
            ];
        DCeq = [];
    end

end