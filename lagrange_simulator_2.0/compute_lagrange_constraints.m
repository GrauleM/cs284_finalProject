function c=compute_lagrange_constraints(q,qdot,qddot,params)

%Derivatives of Vc with respect to qk
dVc_dq=E*I/L*[q1;q2;q3];

%Derivatives of Tkin with respect to qk
dTkin_dq1=rho*numerical_integrator(fun,q,qdot,qddot,L);


end