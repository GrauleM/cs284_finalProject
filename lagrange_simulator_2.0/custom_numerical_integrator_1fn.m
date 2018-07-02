function out=custom_numerical_integrator_1fn(fun,q,qdot,qddot,L)
% using Gauss-Legendre Quadrature to integrare the function f(s_hat) (supplied as
% function handle fun) twice.

% approximates the following integral (latex formatting): 
% \int_0^L \int_0_s f(s_hat) ds_hat ds

% inner integration in s_hat; bounds: 0 to s
% outer integration in s; bounds: 0 to L

% Gauss-Legendre knotpoints and weights of the inner integration
% approximation
xi_i=[0,0.538469,-0.538469,0.90618,-0.90618];
wi_i=[0.568889,0.478629,0.478629,0.236927,0.236927];

% Gauss-Legendre knotpoints and weights of the outer integration
% approximation
xi_o=xi_i;
wi_o=wi_i;

out=0;

for j=1:len(wi_o)
    inner_sum=0;
    for i=1:len(wi_o)
        summand=wi_i(i)*fun(L*(xi_o(j)+1)*(xi_i(i)+1)/4,q,qdot,qddot);
        inner_sum=inner_sum+summand;
    end
    out=out+(xi_o(j)+1)*wi_o(j)*inner_sum;
end

out=out*L^2/8;
    
end