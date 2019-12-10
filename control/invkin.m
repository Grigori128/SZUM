function dtheta = invkin(t,theta,cel)
%Funkcja realizuje zadanie kinematyki odwrotnej
% wektor predkosci katowych = invkin(wektor czasu,wektor katow konfiguracyjnych,funkcja anonimowa określająca zadane prędkości postępowe)

%zadane predkosci koncowki roboczej
c=cel(t);

%uzycie funkcji na kinematyke prosta
[P,A1,Hat] = kin(theta);

%obliczanie predkosci katowych glowy robota
p2_g = P{2};
A1_g = A1{1};
hatS1_g = Hat{1};
hatS2_g = Hat{2};

J_g = [hatS1_g*p2_g, A1_g*hatS2_g*inv(A1_g)*p2_g];
x_g = inv(J_g(1:2,:))*[c(1,1);c(1,2)];
dtheta(1:2,1) = x_g(1:2);

%obliczanie predkosci katowych uda robota
p2_u = P{4};
A1_u = A1{2};
hatS1_u = Hat{3};
hatS2_u = Hat{4};

J_u = [hatS1_u*p2_u, A1_u*hatS2_u*inv(A1_u)*p2_u];
x_u = inv(J_u(1:2,:))*[c(2,1);c(2,2)];
dtheta(3:4,1) = x_u(1:2);

end
