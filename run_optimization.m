% x = [Na1,Na2,Fc1,Fc2,Fc3,c1,c2,c3,alpha1,alpha2,alpha3,L]

q_des=[-.1,-.1,.3,1];

%Params
    %cost function multipliers
    multiplication_factor=1;
    phys_sln_multFactor=1;
    
    %Actuator stuff
    r_actuator=0.02; %actuator diameter in meter
    I_actuator=1./4.*pi*r_actuator^4; %moment of inertia of actuator
    A_actuator=pi.*r_actuator^2;
    Aeff=A_actuator;
    d=0.05; %distance from center (spine) to middle of actuator

    %Stiffness
    L0=1; %1cm
    %E=0.05*10^9; %the Youngs modulus of silicone rubber is 0.05GPa
    %I=2.*(I_actuator+d^2.*A_actuator);
    
    E=2;
    I=1;

   
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
q0=[0,0,0,L0];
x0 = rand(1,12)./10;            % Starting guess 
x0(12)=q0(4);
x0(9:12)=q0;
x0(1:5)=x0(1:5).*E.*I;






options = optimoptions(@fmincon,'Algorithm','sqp','Display','iter');
options = optimoptions(options,'SpecifyObjectiveGradient',true,'SpecifyConstraintGradient',false);
options = optimoptions(options,'MaxFunctionEvaluations',10000);

lb = [ ]; ub = [ ];   % No upper or lower bounds
[x,fval] = fmincon(@(x)objfungrad(x,params),x0,[],[],[],[],lb,ub,... 
   @(x)confungrad(x,q_des,params),options);
%%
q_final=x(9:12);
contacts=x(6:8);
h1=figure(1);
clf;
axis equal
visualize_q(q_des,L0,h1,[1,0,0],'-');
%visualize_q_wContact(q_final,contacts,L0,h,[0,0,0],'--');
contactForces=x(3:5);
forceScaler=.1;
visualize_q_wContact_andContForces(q_final,contacts,contactForces,forceScaler,L0,h1,[0,0,0],'--');


h2=figure(2);
clf;
visualize_q(q_des,L0,h2,[1,0,0],'-');
visualize_q_wContact(q_final,contacts,L0,h2,[0,0,0],'--');


forces=x(1:5);
figure(3);
clf;
bar(forces);
barlabels={'N_{a1}'; 'N_{a1}'; 'F_{c1}';'F_{c2}';'F_{c3}' };
set(gca,'xticklabel',barlabels);
d=0.05;
Ma=d*(x(2)-x(1))



