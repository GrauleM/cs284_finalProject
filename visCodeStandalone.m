%% visualization code
endPose_scaler=0.1; %to make sure the endpoint orientation line is plotted with reasonable scale in the visualization (purely cosmetic)
forceScaler=.01; % to make sure forces are plotted at good scale (purely cosmetic)

q_final=x(9:12);
contacts=x(6:8);
h1=figure(1);
clf;
hold on
axis equal
%visualize_q(q_des,L0,h1,[1,0,0],'-');
%visualize_q_wContact(q_final,contacts,L0,h,[0,0,0],'--');
visualize_endPose(endPose_des,h1,[1,0,0],endPose_scaler)
visualize_endPose_from_q(q_final,L0,h1,[0,0,0],endPose_scaler);
contactForces=x(3:5);
visualize_q_wContact_andContForces(q_final,contacts(1),contactForces,forceScaler,L0,h1,[0,0,0],'-');
%add the obstacle to the figure
viscircles(obst(1:2),obst(3))

h2=figure(2);
clf;
visualize_q_wContact(q_final,contacts,L0,h2,[0,0,0],'-');


forces=x(1:5);
figure(3);
clf;
bar(forces);
barlabels={'N_{a1}'; 'N_{a1}'; 'F_{c1}';'F_{c2}';'F_{c3}' };
set(gca,'xticklabel',barlabels);

%some info for sanity checks
Ma=d*(x(2)-x(1))
Na=x(1)+x(2)
length_constraint=q_final(4)-L0-Na./(Aeff.*E)

%Fix Figure for writup
figure(1);
fig=gcf;
fig.Units='inches';
fig.Position(1:2)=[1,1]
fig.Position(3:4)=[6.5/4*1.75,1.5*1.75]

ax=gca
ax.FontSize=16;
ax.XLim=[0,1.3];
ax.YLim=[-1,0.3];

