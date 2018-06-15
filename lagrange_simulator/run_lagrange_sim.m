% run lagrange optimization

nr_timesteps=10;

params=nr_timesteps;

Ma_des=zeros(nr_timesteps,1);
Ma_des(5:end)=Ma_des(5:end)+10;

x0=zeros(1,(3*3+1)*nr_timesteps);

options = optimoptions(@fmincon,'Algorithm','sqp','Display','iter');
options = optimoptions(options,'ConstraintTolerance',1e-6,...
                               'FunctionTolerance',1e-6);
options = optimoptions(options,'SpecifyObjectiveGradient',false,'SpecifyConstraintGradient',false);
options = optimoptions(options,'MaxFunctionEvaluations',10000);

lb = [ ]; ub = [ ];   % No upper or lower bounds
[x,fval] = fmincon(@(x)objective_lagrange_v1(x,Ma_des,params),x0,[],[],[],[],lb,ub,... 
   @(x)lagrange_constraints_v1(x,params),options);

