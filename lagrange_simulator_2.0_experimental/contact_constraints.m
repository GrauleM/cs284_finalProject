function [c_contact,ceq_contact]=contact_constraints(states,forces,slackVariables,obst,L)

% inequality constraints 
c_contact=[];

% equality constraints 
ceq_contact=[];

% number of contact forces
N_contacts=size(slackVariables,1);

% number of time points
N_timePoints=size(slackVariables,2);

% directionality vector for contact force
% define some helper functions
% phi     =@(s,q,qdot,qddot)          q(1).*s./L+q(2).*(s.^2./L.^2-s./L)+q(3).*(2.*s.^3./L.^3-3.*s.^2./L.^2+s./L); %xx todo: replace with global phi


%direction of contact force at contact point defined by c
force_direction = @(s,q,qdot,qddot,L) [...
                        sin(phi(s,q,qdot,qddot,L));...
                        -cos(phi(s,q,qdot,qddot,L))];

% may be more efficient solutions than redefining these functions and helpers so many times                    
% integration helper functions
% these functions need to be integrated from 0 to s to get x(s) and y(s)        
x_helper=@(s,q,qdot,qddot)          cos(phi(s,q,qdot,qddot,L));
y_helper=@(s,q,qdot,qddot)          sin(phi(s,q,qdot,qddot,L));


for i=1:N_timePoints %for each time point %xx for speed-up, remove for loops and changing array sizes
    
    for j=1:N_contacts %for each contact point at the given timePoint i %xx for speed-up, remove for loops and changing array sizes
        
        Fc=forces(j+1,i);%contact force
        c=forces(j+1+N_contacts,i);  %contact location on manipulator is c*L; 
        y=slackVariables(j,i);% current slack variable
        
        %ensure that the contact point is on the manipulator (i.e. arch length
        %for the point is between 0 and manipulator length L, i.e. c is between 0 and 1)
        c_contact=[c_contact;-c;c-1.];
        
        
        %make sure that the contact point is not IN the obstacle 
        guard_constr=evaluate_guardFn_obstacle(states(:,i),c,obst,L);
        c_contact=[c_contact;guard_constr];

        %ensure that slack variable is positive (DONT forget that these
        %slack variables need to be driven to 0 through the optimisation
        %objective
        c_contact=[c_contact;-y];

        %complementarity constraint
        ceq_contact=[ceq_contact;guard_constr.*Fc-y];
        
        %direction of contact force
        q=states(1:3,i); qdot=[]; qddot=[];
        current_force_direction=force_direction(c.*L,q,qdot,qddot,L);

        %compute position of point P (integrate from 0 to s_p*L)
        xp=custom_numerical_integrator_1fn_once(...
           x_helper,...
           q,qdot,qddot,c.*L);
        yp=custom_numerical_integrator_1fn_once(...
           y_helper,...
           q,qdot,qddot,c.*L);
        
        %make sure that the contact point c is the point on the manipulator
        %which is closest to the obstacle center (either local minimum OR
        %c=0 OR c=1 - hence the multiplications)
        % ceq_closestPoint=(tan(phi(c.*L,q,qdot,qddot,L))+(obst(1)-xp)/(obst(2)-yp))*c*(c-1);
        % ceq_contact=[ceq_contact;ceq_closestPoint];
          
        % ensure that contact force points away from the obstacle
        contact_direction=[xp;yp]-[obst(1);obst(2)];
        c_direction=-Fc*current_force_direction'*contact_direction; %xx unsure if its better to use sign(Fc) or just Fc here
        c_contact=[c_contact;c_direction];

        
    end
    
end



end