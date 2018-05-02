L_0=5;
L=5;
q_0=[0,0,0,L_0]; % this code is only capable to handle initial curvatures of 0; slight adjustments are required for the more general case
q=[0,.1,1,L];
all_s=(0:.001:1).*q(4); 
length(all_s)
%w_hat,phi=compute_curvature_andAngle(q,s);

x_s=zeros(size(all_s)); %initialize as 0 vector
y_s=zeros(size(all_s));

phi_s = @(s) q(1)./q(4).*s+q(2)./q(4).*(s.^2./q(4)-s)+q(3)./q(4).*(2.*s.^3./q(4).^2-3.*s.^2./q(4)+s);
cos_phi_s =@(s) cos(q(1)./q(4).*s+q(2)./q(4).*(s.^2./q(4)-s)+q(3)./q(4).*(2.*s.^3./q(4).^2-3.*s.^2./q(4)+s));  
sin_phi_s =@(s) sin(q(1)./q(4).*s+q(2)./q(4).*(s.^2./q(4)-s)+q(3)./q(4).*(2.*s.^3./q(4).^2-3.*s.^2./q(4)+s));  

all_phi=phi_s(all_s);
length(x_s)
for i=1:length(x_s)
    x_s(i)=integral(cos_phi_s,0,all_s(i)); %xx here it may be better to do gauss-legendre quadrature
    y_s(i)=integral(sin_phi_s,0,all_s(i)); %xx here it may be better to do gauss-legendre quadrature

end

plot(x_s,y_s)

% 
% function [w_hat,phi]=compute_curvature_andAngle(q,s)
% 
%    w_hat=q(1)./q(4)+q(2)./q(4).*(2.*s./q(4)-1)+q(3)./q(4).*(6.*s.^2./q(4).^2-6.*s./q(4)+1);
%    
%    phi=q(1)./q(4).*s+q(2)./q(4).*(s.^2./q(4)-s)+q(3)./q(4).*(2.*s.^3./q(4).^2-3.*s.^2./q(4)+s);
%    
% end




