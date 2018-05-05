% this version runs the optimization with the desired 
% END EFFECTOR POSE as part of the cost to be optimized

% V5 only allows for one contact forces which has to come FROM the obstacle



% x = [Na1,Na2,Fc1,Fc2,Fc3,c1,c2,c3,alpha1,alpha2,alpha3,L]

%obstacle obst=[x_obstacle,y_obstacle,r_obstacle]: obstacle position and radios
obst=[.45,.05,.05];

%TODO: Add the final state to the cost function
%TODO: See if changing tolerances does anything.


q_des=[-.1,-.1,.5,1];
endPose_des = [.9,0.2,.1*pi];


%Params
    %cost function multipliers
    multiplication_factor=1;
    phys_sln_multFactor=100000000;
    
    %Actuator stuff
    r_actuator=0.02; %actuator diameter in meter
    I_actuator=1./4.*pi*r_actuator^4; %moment of inertia of actuator
    A_actuator=pi.*r_actuator^2;
    Aeff=2.*A_actuator;
    d=0.05; %distance from center (spine) to middle of actuator

    %Stiffness
    L0=1; %1cm
    E=0.05*10^9; %the Youngs modulus of silicone rubber is 0.05GPa
    I=2.*(I_actuator+d^2.*A_actuator);
    
   
    %Build params vector
    params=[ multiplication_factor,...
             phys_sln_multFactor,...
             d,...
             L0,...
             E,...
             I,...            
             Aeff];


%Initialization of the guess
L0=1; %unstretched length in m
q0=[0,0,0,1.*L0];
x0 = rand(1,12)./10;            % Starting guess 
x0(12)=q0(4);
x0(9:12)=q0;
x0(1:5)=x0(1:5).*E.*I;

x0(6)=.5; %initialize contact point near middle




%Set simulation options
%Tolerances: default = 1e-6
options = optimoptions(@fmincon,'Algorithm','sqp','Display','iter');
options = optimoptions(options,'ConstraintTolerance',1e-6,...
                               'FunctionTolerance',1e-6);
options = optimoptions(options,'SpecifyObjectiveGradient',false,'SpecifyConstraintGradient',false);
options = optimoptions(options,'MaxFunctionEvaluations',10000);

lb = [ ]; ub = [ ];   % No upper or lower bounds
[x,fval] = fmincon(@(x)objective_v5(x,endPose_des,params,obst),x0,[],[],[],[],lb,ub,... 
   @(x)constraints_v5(x,params,obst),options);
%%
endPose_scaler=0.1;
q_final=x(9:12);
contacts=x(6:8);
h1=figure(1);
clf;
hold on
axis equal
%visualize_q(q_des,L0,h1,[1,0,0],'-');
%visualize_q_wContact(q_final,contacts,L0,h,[0,0,0],'--');
visualize_endPose(endPose_des,h1,[0,0,0],endPose_scaler)
visualize_endPose_from_q(q_final,L0,h1,[1,0,0],endPose_scaler);
contactForces=x(3:5);
forceScaler=.001;
visualize_q_wContact_andContForces(q_final,contacts,contactForces,forceScaler,L0,h1,[0,0,0],'--');

%add the obstacle
viscircles(obst(1:2),obst(3))

h2=figure(2);
clf;
visualize_q_wContact(q_final,contacts,L0,h2,[0,0,0],'--');


forces=x(1:5);
figure(3);
clf;
bar(forces);
barlabels={'N_{a1}'; 'N_{a1}'; 'F_{c1}';'F_{c2}';'F_{c3}' };
set(gca,'xticklabel',barlabels);
d=0.05;
Ma=d*(x(2)-x(1))


