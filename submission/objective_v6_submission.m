function [f,gradf] = objective_v6_submission(x,endPose_des,params,obst,cost_multipliers)
    
    % this version of the objective function contains a cost on the
    % applied forces AND a cost on deviation from the desired configuration
    % in generalized coordinates
    
    % x = [Na1,Na2,Fc1,Fc2,Fc3,c1,c2,c3,alpha1,alpha2,alpha3,L,comp_slack]
    % setting the cost on state variables to zero here

    
    k1=cost_multipliers(1);
    k2=cost_multipliers(2);
    k3_1=cost_multipliers(3);
    k3_2=cost_multipliers(4);
    k4=cost_multipliers(5);
    k5=cost_multipliers(6);
    k6=cost_multipliers(7);
    
    
    q=x(9:12);
    c_vec=x(6:8);

    comp_slack=x(13);
    R=zeros(13);
    R(1,1)=k1;
    R(2,2)=k1;
    R(3,3)=k2;
    R(4,4)=k2;
    R(5,5)=k2;
    
    Q=eye(3);
    Q(1:2,1:2)=k3_1*Q(1:2,1:2); % put higher cost on deviations in position
    Q=k3_2*Q;
    
    Q_dist=1.*k4;
    
    %helper functions
    phi_s = @(s) q(1)./q(4).*s+q(2)./q(4).*(s.^2./q(4)-s)+q(3)./q(4).*(2.*s.^3./q(4).^2-3.*s.^2./q(4)+s);
    cos_phi_s =@(s) cos(phi_s(s));  
    sin_phi_s =@(s) sin(phi_s(s));  
    
    %tip position
    xt = integral(cos_phi_s,0,q(4));
    yt = integral(sin_phi_s,0,q(4));
    
    %pose error
    endPose=[xt,yt,q(1)];
    deviation=endPose-endPose_des;
    
    %included in objective: incentive to reduce distance between obstacle and contact
    %point c1 to drive solution towards contact
        
    xc = integral(cos_phi_s,0,c_vec(1).*q(4)); %position of contact point
    yc = integral(sin_phi_s,0,c_vec(1).*q(4));
    
    dist_to_obst=((obst(1)-xc).^2+(obst(2)-yc).^2).^0.5; %distance between contact point and obstacle center
    
    
    f=x*R*x'+deviation*Q*deviation'+Q_dist*dist_to_obst+k5*comp_slack-k6*x(3);
    

end