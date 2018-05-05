function visualize_endPose_from_q(q,L_0,figHandle,color,scaler)

    % this code is only capable of handling initial curvatures of 0; slight adjustments are required for the more general case


    phi_s = @(s) q(1)./q(4).*s+q(2)./q(4).*(s.^2./q(4)-s)+q(3)./q(4).*(2.*s.^3./q(4).^2-3.*s.^2./q(4)+s);
    cos_phi_s =@(s) cos(phi_s(s));  
    sin_phi_s =@(s) sin(phi_s(s));  

    xt=integral(cos_phi_s,0,q(4)); %xx here it may be better to do gauss-legendre quadrature
    yt=integral(sin_phi_s,0,q(4)); %xx here it may be better to do gauss-legendre quadrature
    phi_t=q(1);
    
    
    figure(figHandle);
    hold on
    plot(xt,yt,'o','Color',color);
    line([xt,xt+scaler*cos(phi_t)],[yt,yt+scaler*sin(phi_t)],'Color',color)


end