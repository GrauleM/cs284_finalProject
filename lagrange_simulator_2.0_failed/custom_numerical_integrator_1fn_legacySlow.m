function out=custom_numerical_integrator_1fn_legacySlow(fun,q,qdot,qddot,L)
% using Gauss-Legendre Quadrature to integrare the function f(s_hat) (supplied as
% function handle fun) twice.

% approximates the following integral (latex formatting): 
% \int_0^L \int_0_s f(s_hat) ds_hat ds

% inner integration in s_hat; bounds: 0 to s
% outer integration in s; bounds: 0 to L

% Gauss-Legendre knotpoints and weights of the inner integration
% approximation
%order n=5
xi_i=[0,0.538469,-0.538469,0.90618,-0.90618];
wi_i=[0.568889,0.478629,0.478629,0.236927,0.236927];
%order n=16 (from 
% xi_i=[ 0.095012509837637, -0.095012509837637,...
%        0.281603550779259, -0.281603550779259,...
%        0.458016777657227, -0.458016777657227,...
%        0.617876244402644, -0.617876244402644,...
%        0.755404408355003, -0.755404408355003,...
%        0.865631202387832, -0.865631202387832,...
%        0.944575023073233, -0.944575023073233,...
%        0.989400934991650, -0.989400934991650];
%    
% wi_i=[ 0.189450610455069, 0.189450610455069,...
%        0.182603415044924, 0.182603415044924,...
%        0.169156519395003, 0.169156519395003,...
%        0.149595988816577, 0.149595988816577,...
%        0.124628971255534, 0.124628971255534,...
%        0.095158511682493, 0.095158511682493,...
%        0.062253523938648, 0.062253523938648,...
%        0.027152459411754, 0.027152459411754];


% Gauss-Legendre knotpoints and weights of the outer integration
% approximation
xi_o=xi_i;
wi_o=wi_i;

out=0;

for j=1:length(wi_o)
    inner_sum=0;
    for i=1:length(wi_o)
        summand=wi_i(i).*fun(L.*(xi_o(j)+1).*(xi_i(i)+1)/4,q,qdot,qddot);
        inner_sum=inner_sum+summand;
    end
    out=out+(xi_o(j)+1)*wi_o(j)*inner_sum;
end

out=out*L^2/8;
    
end