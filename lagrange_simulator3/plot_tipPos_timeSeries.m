function plot_tipPos_timeSeries(forces,q_series,L0,figHandle,h)

    %h in input is the time step length
    % xx quick and dirty out of laziness
    N_steps=size(q_series,2);
    figure(figHandle);
    hold on

    timePoints=0:h:(N_steps-1)*h;
    
    x_tip=[];
    y_tip=[];
    
    for t=1:N_steps
        % this code is only capable of handling initial curvatures of 0; slight adjustments are required for the more general case
        q=[q_series(:,t);L0]; %xx quick hack to be able to use the old visualization function
        all_s=q(4); 

 

        phi_s = @(s) q(1)./q(4).*s+q(2)./q(4).*(s.^2./q(4)-s)+q(3)./q(4).*(2.*s.^3./q(4).^2-3.*s.^2./q(4)+s);
        cos_phi_s =@(s) cos(phi_s(s));  
        sin_phi_s =@(s) sin(phi_s(s));  

        
        x_tip=[x_tip,integral(cos_phi_s,0,all_s)];
        y_tip=[y_tip,integral(sin_phi_s,0,all_s)];

       
    end
    subplot(3,1,1)
    plot(timePoints,x_tip,'LineWidth',2);
    %xlabel('time [s]')
    ylabel('tip position (x)')
    subplot(3,1,2)
    plot(timePoints,y_tip,'LineWidth',2);
    %xlabel('time [s]')
    ylabel('tip position (y)')
    subplot(3,1,3)
    plot(timePoints,forces(1,:),'LineWidth',2);
    xlabel('time [s]')
    ylabel('tip moment')
end