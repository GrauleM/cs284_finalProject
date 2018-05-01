function visualize_q(q,L_0,figHandle,color,style)

    % this code is only capable of handling initial curvatures of 0; slight adjustments are required for the more general case
    all_s=(0:.001:1).*q(4); 

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
    figure(figHandle);
    hold on
    plot(x_s,y_s,style,'Color',color);


end