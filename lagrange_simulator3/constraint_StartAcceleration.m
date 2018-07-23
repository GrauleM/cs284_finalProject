function ceq_start = constraint_StartAcceleration(qddot_desired,resulting_states_timeSeries,h)
%ensures that the start acceleration is at qddot=qddot_desired (using
%midpoint approx)

ceq_start=qddot_desired-(resulting_states_timeSeries(4:6,2)-resulting_states_timeSeries(4:6,1))/h;

end