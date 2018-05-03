function visualize_endPose(endPose,figHandle,color,scaler)

    % this code is only capable of handling initial (undeformed) curvatures of 0; slight adjustments are required for the more general case

    xt=endPose(1); %xx here it may be better to do gauss-legendre quadrature
    yt=endPose(2); %xx here it may be better to do gauss-legendre quadrature
    phi_t=endPose(3);
    
    
    figure(figHandle);
    hold on
    plot(xt,yt,'o','Color',color);
    line([xt,xt+scaler*cos(phi_t)],[yt,yt+scaler*sin(phi_t)],'Color',color)


end