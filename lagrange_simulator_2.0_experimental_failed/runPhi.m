%run phi and text mex code. result: mex slower

q_val=[1;1;1]; qdot_val=[1;1;1];qddot_val=[1;1;1];
c=0.5;
L=1;

for i=1:100000
phi_test=phi([c.*L,L;0,1.*c],q_val,qdot_val,qddot_val,L);

phi_test2=phi_mex([c.*L,L;0,1.*c],q_val,qdot_val,qddot_val,L);
end
