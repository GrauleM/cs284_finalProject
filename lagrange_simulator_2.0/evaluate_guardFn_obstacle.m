function dist = evaluate_guardFn_obstacle(states,s_p,obst,L)
% computes the distance between the obstacle boundary and points P on the 
% manipulator (each point is defined by respective s_p, where s_p goes from 0 to 1)
% arc length s for point P is s_p*L (L being total manipulator length)

% for now, this is assuming constant manipulator length L

% each colum in states is a time point
% each colum in s_p is a time point; function also works for multiple (N)
% points - in that case, s_p has N rows

%obstacle obst=[x_obstacle,y_obstacle,r_obstacle]: obstacle center position and radius

% output dist is a matrix of distances with N rows. each colum in dist is a time point

% define some helper functions
phi     =@(s,q)     q(1)*s/L+q(2)*(s^2/L^2-s/L)+q(3)*(2*s^3/L^3-3*s^2/L^2+s/L);

% integration helper functions
% these functions need to be integrated from 0 to s to get x(s) and y(s)        
x_helper=@(s,q)          cos(phi(s,q));
y_helper=@(s,q)          sin(phi(s,q));


dist=zeros(size(s_p));

for i=1:size(states,2)
    q=states(1:3,:);
    qdot=[]; 
    qddot=[];
    
    for j=1:size(s_p,1)
        
       %compute position of point P (integrate from 0 to s_p*L)
       xp=custom_numerical_integrator_1fn(...
           x_helper,...
           q,qdot,qddot,s_p.*L);
       yp=custom_numerical_integrator_1fn(...
           y_helper,...
           q,qdot,qddot,s_p.*L);
       
       dist(j,i)=sqrt((obst(1)-xp)^2+(obst(2)-yp)^2)-obst(3);
       
    end     
    
end

end