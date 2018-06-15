function [f,gradf] = objective_lagrange_v1(x,Ma_des,params)    

    %x=[q(t=1), q_dot(t=1), q_ddot(t=1), M(t=1),q(t=2) ...,
    %Ma(t=k)];
    
    nr_timesteps=params(1)

    Ma_actual=zeros(nr_timesteps,1)
    
    for t=1:nr_timesteps
        t
        (t-1)*4+4
        Ma_actual(t)=x( (t-1)*4+4);
    end
 
    f=(Ma_actual-Ma_des)'*(Ma_actual-Ma_des);

end