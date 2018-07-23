function visualize_q_timeSeries(q_series,L0,figHandle,color,style,xl,yl)

    N_steps=size(q_series,2);
    figure(figHandle);
    hold on

    for t=1:N_steps
        % this code is only capable of handling initial curvatures of 0; slight adjustments are required for the more general case
        q=[q_series(:,t);L0]; %xx quick hack to be able to use the old visualization function
        all_s=(0:.001:1).*q(4); 

        x_s=zeros(size(all_s)); %initialize as 0 vector
        y_s=zeros(size(all_s));

        phi_s = @(s) q(1)./q(4).*s+q(2)./q(4).*(s.^2./q(4)-s)+q(3)./q(4).*(2.*s.^3./q(4).^2-3.*s.^2./q(4)+s);
        cos_phi_s =@(s) cos(phi_s(s));  
        sin_phi_s =@(s) sin(phi_s(s));  

        all_phi=phi_s(all_s);
        length(x_s);
        for i=1:length(x_s)
            x_s(i)=integral(cos_phi_s,0,all_s(i)); %xx here it may be better to do gauss-legendre quadrature
            y_s(i)=integral(sin_phi_s,0,all_s(i)); %xx here it may be better to do gauss-legendre quadrature

        end
        subplot(ceil(sqrt(N_steps)),ceil(N_steps/ceil(sqrt(N_steps))),t)
        plot(x_s,y_s,style,'Color',color,'LineWidth',2);
        title(['time step',num2str(t)]);
        axis equal;
        xlim(xl);
        ylim(yl);
    end

end