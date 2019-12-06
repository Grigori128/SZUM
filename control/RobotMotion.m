function RobotMotion(C)
try
	% C = 1:6; 


	try
	rostopic list;
	catch
	rosinit;
	end

	% rossubscriber
	state = rossubscriber("/darwin/joint_states");

	% rospublisher
	t = rospublisher("darwin/j_tilt_position_controller/command"); %(szyja i glowa)
	p = rospublisher("/darwin/j_pan_position_controller/command"); 

	bl = rospublisher("/darwin/j_thigh1_l_position_controller/command"); %(uda - na boki)
	br = rospublisher("/darwin/j_thigh1_r_position_controller/command"); 

	ul = rospublisher("/darwin/j_thigh2_l_position_controller/command"); %(uda - uklon)
	ur = rospublisher("/darwin/j_thigh2_r_position_controller/command");

	% rosmessage
	tm = rosmessage(t.MessageType);
	pm = rosmessage(p.MessageType);

	blm = rosmessage(bl.MessageType);
	brm = rosmessage(br.MessageType);

	ulm = rosmessage(ul.MessageType);
	urm = rosmessage(ur.MessageType);


	%% Zdefiniowanie celu

	%cel = @(time)[vx_g vy_g vx_u vy_u];

	switch C
	    case 0
		reset = 1;
	    case 1
		%dojazd na okreg
		cel{1} = @(time)[0, 0.1; 0, 0];
		t_end(1) = 0.5;
		%krecenie glowa
		cel{2} = @(time)[0.2*sin(time), 0.2*cos(time); 0, 0];%[0.12*sin(t+pi), 0.12*cos(t+pi); -0.005*sin(t), 0.010*cos(t)];
		t_end(2) = 10*pi;
		%powrot
		cel{3} = @(time)[0, -0.1; 0, 0];
		t_end(3) = 0.5;
		n = 3; %liczba czynnosci
		reset = 0;
	    case 2
		%uklon
		cel{1} = @(time)[0, 0; 0.02, 0];
		t_end(1) = 2.5;
        %kiwniecie
		cel{2} = @(time)[-0.2, 0; 0, 0];
		t_end(2) = 0.5;
		%powrot do pionu głowy
		cel{3} = @(time)[0.2, 0; 0, 0];
		t_end(3) = 0.5;
		%powrot do pionu
		cel{4} = @(time)[0, 0; -0.02, 0];
		t_end(4) = 2.5;
		n = 4; %liczba czynnosc 
		reset = 0;
	    case 3
		%dojazd na okreg 
		cel{1} = @(time)[0.2, 0; -0.01, 0];
		t_end(1) = 0.5;
		%krecenie torsem poprzez biodra 
		cel{2} = @(time)[0, 0; 0.005*sin(time), 0.02*cos(time)];
		t_end(2) = 10*pi;
		%powrot
		cel{3} = @(time)[-0.2, 0; 0.01, 0.0];
		t_end(3) = 0.5;
		n = 3; %liczba czynnosci 
		reset = 0;
	    case 4
		% kiwanie glowa - znak tak
		cel{1} = @(time)[0.2, 0; 0, 0];
		t_end(1) = 2;
		 cel{2} = @(time)[-0.4, 0; 0, 0];
		t_end(2) = 2;
		 cel{3} = @(time)[0.2, 0; 0, 0];
		t_end(3) = 2;
		n = 3; %liczba czynnosci
		reset = 0;  
	    case 5
		% kiwanie glowa - znak nie
		cel{1} = @(time)[0, 0.1; 0, 0];
		t_end(1) = 2;
		 cel{2} = @(time)[0, -0.2; 0, 0];
		t_end(2) = 2;
		 cel{3} = @(time)[0, 0.1; 0, 0];
		t_end(3) = 2;
		n = 3; %liczba czynnosci
		reset = 0;  
	    case 6
		%dojazd na okregi
		cel{1} = @(time)[0.1, 0.1; -0.01, 0];
		t_end(1) = 0.5;
		%krecenie torsem i glowa 
		cel{2} = @(time)[0.2*sin(time), 0.2*cos(time); 0.005*sin(time), 0.02*cos(time)];
		t_end(2) = 10*pi;
		%powrot
		cel{3} = @(time)[-0.1, -0.1; 0.01, 0.0];
		t_end(3) = 0.5;
		n = 3; %liczba czynnosci 
		reset = 0;
	    case 7
		%dojazd
        	cel{1} = @(time)[0.2, 0; 0, 0];
        	t_end(1) = 0.5;
        	%
        	cel{2} = @(time)[0, -0.3; 0, 0];
        	t_end(2) = 0.5;
        	%osemki
        	cel{3} = @(time)[0.2*cos(2*time),0.2*sin(time); 0, 0];
        	t_end(3) = 32;
        	%powrot
        	cel{4} = @(time)[-0.2, 0; 0, 0];
        	t_end(4) = 0.5;
        	%
        	cel{5} = @(time)[0, 0.3; 0, 0];
        	t_end(5) = 0.5;
        	%
        	n = 5;
        	reset = 0;
            case 8
        %dojazd
        cel{1} = @(time)[0.1, 0; 0, 0];
        t_end(1) = 0.5;
        %ryba
        cel{2} = @(time)[0.3*sin(3*time+pi/4), 0.3*cos(2*time); 0, 0];
        t_end(2) = 32;
        %powrot
        cel{3} = @(time)[-0.1, 0; 0, 0];
        t_end(3) = 0.5;
        n = 3; %liczba czynnosci
        reset = 0;  
	   
	end

	%% Petla

	if reset == 0

	    TH = [];
	    for j = 1:n
		for i = 0:0.1:(t_end(j)-0.1)

		    %odbior informacji z robota
		    stan = receive(state,1);

		    th0 = [stan.Position(22) stan.Position(11) stan.Position(16) stan.Position(18)];

		    %uklad sterowania
		    %obliczanie sterowania z wykorzystaniem solvera ode45 oraz funkcji na kinematyke odwrotna robota

		    tspan = i:0.05:(i+0.1);
		    [time,th] = ode45(@(time,th) invkin(time,th,cel{j}), tspan, th0);
		    sterowanie = th(end,:);
		    TH = [TH;sterowanie];

		    % wyslanie sterowania do robota
		    tm.Data = sterowanie(1);
		    send(t,tm);
		    
		    pm.Data = sterowanie(2);
		    send(p,pm);

		    blm.Data = sterowanie(3); 
		    send(bl,blm);

		    brm.Data = sterowanie(3); 
		    send(br,brm);

		    ulm.Data = sterowanie(4); 
		    send(ul,ulm);

		    urm.Data = -sterowanie(4); 
		    send(ur,urm);

		    pause(0.01)
		end
	    end

	else
	    % wyzerowanie poszczegolnych czlonow robota
	    tm.Data = 0;
	    send(t,tm);

	    pm.Data = 0;
	    send(p,pm);
	    
	    blm.Data = 0; 
	    send(bl,blm);
	    
	    brm.Data = 0; 
	    send(br,brm);
	    
	    ulm.Data = 0; 
	    send(ul,ulm);

	    urm.Data = 0; 
	    send(ur,urm);

	    pause(0.01)
	    reset = 0;
	end


	%exit;
catch
	display('Błąd symulacji, proszę czekać. Czy symulacja w gazebo jest uruchomiona?');
end
end

