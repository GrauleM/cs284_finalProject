function ceq_start = constraint_StartVelocity(qdot_desired,resulting_states_timeSeries)
%ensures that the start velocity is at qdot=qdot_desired

ceq_start=qdot_desired-resulting_states_timeSeries(4:6,1);

end