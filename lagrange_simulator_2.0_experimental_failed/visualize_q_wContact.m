function visualize_q_wContact(q_in,c_in,L0,figHandle,color,style)

    % visualizes q and contact points
    % this code is only capable of handling unloaded curvatures of 0; slight adjustments are required for the more general case
    
    
    q=[q_in;L0]; %xx quick hack to be able to use the old visualization function
    all_s=(0:.001:1).*q(4); 

    x_s=zeros(size(all_s)); %initialize as 0 vector
    y_s=zeros(size(all_s));

    phi_s = @(s) q(1)./q(4).*s+q(2)./q(4).*(s.^2./q(4)-s)+q(3)./q(4).*(2.*s.^3./q(4).^2-3.*s.^2./q(4)+s);
    cos_phi_s =@(s) cos(phi_s(s));  
    sin_phi_s =@(s) sin(phi_s(s));  

    all_phi=phi_s(all_s);
    for i=1:length(x_s)
        x_s(i)=integral(cos_phi_s,0,all_s(i)); %xx here it may be better to do gauss-legendre quadrature
        y_s(i)=integral(sin_phi_s,0,all_s(i)); %xx here it may be better to do gauss-legendre quadrature

    end
    figure(figHandle);
    hold on
    plot(x_s,y_s,style,'Color',color);
    axis equal
    

    for i=1:length(c_in)
        x_c=integral(cos_phi_s,0,c_in(i)); %xx here it may be better to do gauss-legendre quadrature xx use custom integrators for speedup
        y_c=integral(sin_phi_s,0,c_in(i)); %xx here it may be better to do gauss-legendre quadrature
        plot(x_c,y_c,'o','MarkerFaceColor',color,'MarkerEdgeColor',color);
    end


end