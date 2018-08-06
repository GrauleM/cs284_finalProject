function ceq_start = constraint_StartConfiguration(q_desired,resulting_states_timeSeries)
%ensures that the start configuration is at q=q_desired

ceq_start=q_desired-resulting_states_timeSeries(1:3,1);

end