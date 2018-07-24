function ceq_final = constraint_FinalAcceleration(qddot_desired,resulting_states_timeSeries,h)
%ensures that the final acceleration is at qddot=qddot_desired (using
%midpoint approx)

ceq_final=qddot_desired-(resulting_states_timeSeries(4:6,end)-resulting_states_timeSeries(4:6,end-1))/h;

end