function [c,ceq,DC,DCeq] = lagrange_constraints_v1(x,params)

%x=[q(t=1), q_dot(t=1), q_ddot(t=1), Ma(t=1),q(t=2) ...,
%Ma(t=k)];

nr_timesteps=params(1);

constraints=zeros(3*nr_timesteps,1);
for t=1:nr_timesteps
    
    q=x((t-1)*10+1:(t-1)*10+3)  % xx fix: this needs to be dimension 1 by3
    q_dot=x((t-1)*4+4:(t-1)*10+6);
    q_ddot=x((t-1)*10+7:(t-1)*10+9);
    Ma=x((t-1)*10+10);
    [constraints(1+(t-1)*3),constraints(2+(t-1)*3),constraints(3+(t-1)*3)]...
        =compute_lagrange_constraints(q,q_dot,q_ddot,Ma);
    
end

c=[];
ceq=constraints';

DC=[];
DCeq=[];
end
