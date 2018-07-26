function out=custom_numerical_integrator_2fn(fun1,fun2,q,qdot,qddot,L)
% using Gauss-Legendre Quadrature to integrare the product of the integrals of the functions f1(s_hat) and f2(s_hat) (supplied as
% function handles fun1,fun2).

% approximates the following integral (latex formatting): 
% \int_0^L ( \int_0_s f1(s_hat) ds_hat * \int_0_s f2(s_hat) ds_hat ) ds

% inner integration in s_hat; bounds: 0 to s
% outer integration in s; bounds: 0 to L

% Gauss-Legendre knotpoints and weights of the inner integration
% approximation (note:uses same knot points for botyh inner integrations)
xi_i=[0,0.538469,-0.538469,0.90618,-0.90618];
wi_i=[0.568889,0.478629,0.478629,0.236927,0.236927];

% Gauss-Legendre knotpoints and weights of the outer integration
% approximation
xi_o=xi_i;
wi_o=wi_i;

% out=0;
% 
% for j=1:length(wi_o)
% 
%     inner_sum1=wi_i*transpose(fun1(L.*(xi_o(j)+1).*(xi_i+1)/4,q,qdot,qddot))
%     
%     inner_sum2=wi_i*transpose(fun2(L.*(xi_o(j)+1).*(xi_i+1)/4,q,qdot,qddot))
% 
%     
%     out=out+(xi_o(j)+1)^2*wi_o(j)*inner_sum1'*inner_sum2';
% end

s_val2=L.*(xi_o+1)'.*(xi_i+1)./4;
s_val2=s_val2(:)';

inner_sum1=reshape(wi_i*reshape(fun1(s_val2,q,qdot,qddot),[],length(xi_o))',[],length(xi_o));   %this dimension needs to be inferred because it is sometimes length(q) for vector fn or just 1D
inner_sum2=reshape(wi_i*reshape(fun2(s_val2,q,qdot,qddot),[],length(xi_o))',[],length(xi_o));

xio_wio=(xi_o+1).^2.*wi_o; %care, don't forget square here
out=(inner_sum1.*inner_sum2)*xio_wio';



out=out.*L.^3./32;
    
end