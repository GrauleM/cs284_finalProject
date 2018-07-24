function out=phi(s,q,qdot,qddot,L)

out=q(1)*s/L+q(2)*(s^2/L^2-s/L)+q(3)*(2*s^3/L^3-3*s^2/L^2+s/L);

end