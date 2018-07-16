function c_pen=penetration_constraints(states,obst,L)
% for all points on the manipulator, the distance to the obstacle has to be
% greater equal zero

% select number of equally spaced evaluation points along the manipulator
% for which penetration is checked

N_checks=11;

% create s points for the checks
s_p=repmat(linspace(0,1,N_checks),1,size(states,2));

neg_dist = evaluate_guardFn_obstacle(states,s_p,obst,L); %for each point, distance to obstacle center has to be larger than obstacle radius r_o, or: -(dist)+r<=0

c_pen=reshape(neg_dist,[size(neg_dist,1)*size(neg_dist,2),1]);

end
