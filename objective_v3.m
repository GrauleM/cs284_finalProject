function [f,gradf] = objective_v3(x,endPose_des,params)
    
    % this version of the objective function contains a cost on the
    % applied forces AND a cost on deviation from the desired configuration
    % in generalized coordinates
    
    % x = [Na1,Na2,Fc1,Fc2,Fc3,c1,c2,c3,alpha1,alpha2,alpha3,L]
    % setting the cost on state variables to zero here
    
    %CAREFUL: GRADIENT IS WRONG!
    
    q=x(9:12);
    
    k1=.02;
    k2=.01;
    k3=50000000;
    
    R=zeros(12);
    R(1,1)=k1;
    R(2,2)=k1;
    R(3,3)=k2;
    R(4,4)=k2;
    R(5,5)=k2;
    
    Q=eye(3);
    Q(1:2,1:2)=2*Q(1:2,1:2); % put higher cost on deviations in position
    Q=k3*Q;
    
    phi_s = @(s) q(1)./q(4).*s+q(2)./q(4).*(s.^2./q(4)-s)+q(3)./q(4).*(2.*s.^3./q(4).^2-3.*s.^2./q(4)+s);
    
    cos_phi_s =@(s) cos(phi_s(s));  
    sin_phi_s =@(s) sin(phi_s(s));  
    
    %tip position
    xt = integral(cos_phi_s,0,q(4));
    yt = integral(sin_phi_s,0,q(4));
    
    endPose=[xt,yt,q(1)];
    deviation=endPose-endPose_des;
    
    f=x*R*x'+deviation*Q*deviation';
    
    % Gradient of the objective function:
    if nargout  > 1
        gradf=[2*R(1,1)*x(1),...
            2*R(2,2)*x(2),...
            2*R(3,3)*x(3),...
            2*R(4,4)*x(4),...
            2*R(5,5)*x(5),...
            2*R(6,6)*x(6),...
            2*R(7,7)*x(7),...
            2*R(8,8)*x(8),...
            2*Q(1,1)*deviation(1),...
            2*Q(2,2)*deviation(2),...
            2*Q(3,3)*deviation(3),...
            0 ...
            ];
    end

end