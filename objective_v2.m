function [f,gradf] = objective_v2(x,q_des,params)
    
    % this version of the objective function contains a cost on the
    % applied forces AND a cost on deviation from the desired configuration
    % in generalized coordinates
    
    % x = [Na1,Na2,Fc1,Fc2,Fc3,c1,c2,c3,alpha1,alpha2,alpha3,L]
    % setting the cost on state variables to zero here
    
    k1=.02;
    k2=.01;
    k3=5000000;
    
    R=zeros(12);
    R(1,1)=k1;
    R(2,2)=k1;
    R(3,3)=k2;
    R(4,4)=k2;
    R(5,5)=k2;
    
    Q=k3*eye(4);

    deviation=x(9:12)-q_des;
    
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
            2*Q(4,4)*deviation(4),...
            ];
    end

end