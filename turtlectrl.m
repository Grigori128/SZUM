%rosinit
clear 
pozycja = rossubscriber('/turtle1/pose');
sterowanie = rospublisher('/turtle1/cmd_vel');
wiadomosc = rosmessage(sterowanie.MessageType);

%% LAPUNOW
angle = katy(pi/4);
setpoint = [ 5, 5];
eps = 1e-2;
polozenie = receive(pozycja,1);
e = 1e6;
omega = [];
V = [];
theta = [];
while (abs(polozenie.Theta - angle) > eps) || (abs(e) > 1e-6)
    polozenie = receive(pozycja,1);
    
    %zmienne - pozycja robota
    x = polozenie.X - setpoint(1);
    y = polozenie.Y - setpoint(2);
    
    Theta = polozenie.Theta;
    
    %zmienne stanu
    alpha = atan2(y,x) - Theta;
    e = sqrt(x*x + y*y);
    bt = alpha + Theta;
    
    %zmienne sterujace
    v = -e*cos(alpha);
    if abs(e) < 1e-6
        w = -Theta + angle;
    else
        w = sin(alpha)*cos(alpha) + ((bt * cos(alpha)*sin(alpha))/alpha) + alpha;
        %obluga granicy specjalnej
        if isnan(w) == 1
            w = sin(alpha)*cos(alpha) + (bt * cos(alpha)*1) + alpha;
        end
    end
    
    %aktualizacja sterowania
    wiadomosc.Linear.X = v;
    wiadomosc.Angular.Z = w;
    
    send(sterowanie,wiadomosc);
    pause(0.01);
    display(angle);
    display(polozenie.Theta);
    display(polozenie.X);
    display(polozenie.Y);
    theta = [theta, Theta];
    V = [V, v];
    omega = [omega, w];
end

%% WYKRESY
figure(1)
hold on
plot(theta,omega,'k-');
xlabel('kąt kursowy \theta [rad]')
ylabel('podawana prędkość kątowa \omega [rad/s]')
figure(2)
hold on
plot(theta,V,'b-');

