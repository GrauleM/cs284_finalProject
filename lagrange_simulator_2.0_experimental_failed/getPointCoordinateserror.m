function [xp,yp]=getPointCoordinates(c,q,qdot,qddot,L)

% very similar to custom_numerical_integration_1fn.m, but allows for
% multiple c

%q,qdot,qddot: vectors at each time point. for one time point: N by 1
%vectors

%c: contact points (between 0 and 1); N_contacts by N_timePoints

%L: manipulator length

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



x_helper=@(s,q,qdot,qddot)          cos(phi(s,q,qdot,qddot,L));
y_helper=@(s,q,qdot,qddot)          sin(phi(s,q,qdot,qddot,L));

        %compute position of point P (integrate from 0 to s_p*L)

       xp=custom_numerical_integrator_1fn(...
           x_helper,...
           q,qdot,qddot,c.*L);
        yp=custom_numerical_integrator_1fn(...
           y_helper,...
           q,qdot,qddot,c.*L);
       
       % Gauss-Legendre knotpoints and weights of the outer integration
% approximation
xi_o=xi_i;
wi_o=wi_i;

s_val2=(c.*L).*(xi_o+1)'.*(xi_i+1)./4;
s_val2=s_val2(:)';
wi_i_rep=repmat(wi_i',1,length(xi_o));
wi_i_rep=wi_i_rep(:)';
inner_sum=wi_i_rep.*fun(s_val2,q,qdot,qddot);
xio_wio_rep=repelem((xi_o+1).*wi_o,length(xi_o),1); 
xio_wio_rep=xio_wio_rep(:);
out=inner_sum*xio_wio_rep;



out=out.*L.^2./8;



end