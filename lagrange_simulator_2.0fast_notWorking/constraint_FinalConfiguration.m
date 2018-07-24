function ceq_final = constraint_FinalConfiguration(q_desired,resulting_states_timeSeries)
%ensures that the start configuration is at q=q_desired

ceq_final=q_desired-resulting_states_timeSeries(1:3,end);

end