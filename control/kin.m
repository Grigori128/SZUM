function [P,A1,Hat] = kin(theta)
%Na podstawie katów konfiguracyjnych wyznaczane sa polozenia w układzie kartezjanskim
%[polozenia koncowek czlonow w ukladzie kartezjanskim, pomocnicza macierz A1, pomocnicza macierz Hat] = kin(wektor polozen katowych czlonow)
%Macierze A1 oraz Hat wystawiane sa w celu przyspieszenia obliczen jakobianu (ponowne liczenie ZPK nie jest wtedy konieczne)
 
    %obliczanie polozenia glowy robota
    theta1_g = theta(1);
    theta2_g = theta(2);

    w1_g = [0; 1; 0];
    w2_g = [0; 0; 1];

    z_g = 0.50650 - 0.023500;

    u1_g = [0; 0; 0];
    u2_g = [0; 0; z_g]; 

    p10_g = [0; 0; z_g; 1];
    p20_g = [0.25; 0; z_g; 1];

    s1_g = [w1_g;cross(-w1_g,u1_g)];
    s2_g = [w2_g;cross(-w2_g,u2_g)];

    hat = @(s) [0 -s(3) s(2) s(4); s(3) 0 -s(1) s(5); -s(2) s(1) 0 s(6); 0 0 0 0];

    A1_g = expm(hat(s1_g)*theta1_g);
    A2_g = expm(hat(s2_g)*theta2_g);

    p1_g = A1_g*p10_g;
    p2_g = A1_g*A2_g*p20_g;
    
    P(1:2) = {p1_g, p2_g};
    A1{1} = A1_g;
    Hat(1:2) = {hat(s1_g),hat(s2_g)};

    % obliczanie polozenia uda robota
    theta1_u = theta(3);
    theta2_u = theta(4);

    w1_u = [1; 0; 0];
    w2_u = [0; 1; 0];

    z_u = - 0.122202 + 0.093550 - 0.001;

    u1_u = [0; 0;  0];
    u2_u = [0; 0; -0.001];

    p10_u = [0; 0; -0.001; 1];
    p20_u = [0; 0; z_u; 1];

    s1_u = [w1_u;cross(-w1_u,u1_u)];
    s2_u = [w2_u;cross(-w2_u,u2_u)];

    hat = @(s) [0 -s(3) s(2) s(4); s(3) 0 -s(1) s(5); -s(2) s(1) 0 s(6); 0 0 0 0];

    A1_u = expm(hat(s1_u)*theta1_u);
    A2_u = expm(hat(s2_u)*theta2_u);

    p1_u = A1_u*p10_u;
    p2_u = A1_u*A2_u*p20_u;
    
    P(3:4) = {p1_u, p2_u};
    A1{2} = A1_u;
    Hat(3:4) = {hat(s1_u),hat(s2_u)};
    
end
