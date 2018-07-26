%test contact point acceleration

L=1.;

q_val=[1, 0;1 ,-1;1 ,1]; qdot_val=[1, 0;1 ,0;1 ,0];qddot_val=[1, 0;1, 0;1, 0];
q_val=[1;1;1]; qdot_val=[1;1;1];qddot_val=[1;1;1];
c=[0.5;0.2];

x_helper=@(s,q,qdot,qddot)          cos(phi(s,q,qdot,qddot,L));
y_helper=@(s,q,qdot,qddot)          sin(phi(s,q,qdot,qddot,L));


for j=1:size(q_val,2)
for i=1:length(c)
    ci=c(i);
        %compute position of point P (integrate from 0 to s_p*L)
        xp=custom_numerical_integrator_1fn(...
           x_helper,...
           q_val(:,j),qdot_val(:,j),qddot_val(:,j),ci.*L)
        yp=custom_numerical_integrator_1fn(...
           y_helper,...
           q_val(:,j),qdot_val(:,j),qddot_val(:,j),ci.*L)
end
end
[xp_test,yp_test]=getPointCoordinates(c,q_val,qdot_val,qddot_val,L)