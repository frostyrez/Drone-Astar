clear
clf
%tic
% % INITIALISE % %

%DEFINE THE 3-D MAP ARRAY
MAX_X=50;
MAX_Y=50;
MAX_Z=50;
MAP=2*(ones(MAX_X,MAX_Y,MAX_Z));

% % BEGIN Manual Start, Obstacle, Target Input
% Obstacle=-1,Target = 0,Robot=1,Space=2
%reply = [10 40 20 15 10 2 20 20 30 10 3.5 20 20 15 20 3 20 20 20 5 3 20 20 25 20 2 20 20 35 23 20]; %flat
% reply = [10 40 20 15 10 2 15 30 30 10 4 10 25 15 35 3 15 25 20 5 3 18 24 25 20 2 18 22 35 23 20]; %input('Coords :'); %Input Coords
% r = size(reply,2);
% numCyl = (r-6)/5;
% disp([num2str(numCyl),' Obstacles Found']);
% start(1) = reply(1); %Pull Start Coords
% start(2) = reply(2);
% start(3) = reply(3); So here's what i think should happen
start = [40 10 15];%[32 17 40];
target = [10 30 45];%[15 35 15];
moving = [25 35 5 40 29 28 7 39];%[25 15 5 32 35 20 5 33 30 30 5 34 15 15 4 35 25 15 5 36 13 10 4 37]; % x y r z
fixed = [33 11 5 30 38 18 6 35 35 15 4 33]; % x y r z
numCyl = (length(fixed)+length(moving))/4;
MAP(start(1),start(2),start(3))=1;
MAP(target(1),target(2),target(3))=0;
xval = start(1);
yval = start(2);
zval = start(3);
Obst_i = [];
cylCoord = [];

% target(1) = reply(r-2); %Pull Target Coords
% target(2) = reply(r-1);
% target(3) = reply(r);
%moveFig=plot3(move(:,1),move(:,2),move(:,3),'ro');

dirInput = {'N'};
[obsDirec,uamDirecX,uamDirecY,uamDirecZ] = direction(dirInput,start,target);

%%%%%%%%%%%%%%
% CYLCOORD STRUCTURE: |X CENTER |Y CENTER |RADIUS |Z1 |Z2 |
%%%%%%%%%%%%%%
a=1;
k2=1;

for k=1:numCyl % Obtain obstacles within cylinder
    if k <= length(moving)/4 % Populate top of list with moving cylinder coords
        cylCoord(k,1) = moving(k*4-3);
        cylCoord(k,2) = moving(k*4-2);
        cylCoord(k,3) = moving(k*4-1);
        cylCoord(k,4) = moving(k*4);
    else
        cylCoord(k,1) = fixed(k2*4-3); % Populate bottom of list with fixed cylinder coords
        cylCoord(k,2) = fixed(k2*4-2);
        cylCoord(k,3) = fixed(k2*4-1);
        cylCoord(k,4) = fixed(k2*4);
        k2=k2+1;
    end
    
    [x(:,:,k), y(:,:,k), z(:,:,k)] = cylinder(cylCoord(k,3),50); %Define Cylinder
    x(:,:,k) = x(:,:,k)+cylCoord(k,1);
    y(:,:,k) = y(:,:,k)+cylCoord(k,2);
    if k <= length(moving)/4 % if aircraft then thin cylinder at altitude
        z(1,:,k) = cylCoord(k,4)+0.5;
        z(2,:,k) = cylCoord(k,4)-0.5;
    else
        z(2,:,k) = cylCoord(k,4); % if building then cylinder up to altitude
    end
    
    for i=1:MAX_X
        for j=1:MAX_Y
            % Grab obstacles near radius of cylinder, add to closed list and plot
            %             if ( (distance(cylCoord(k,1),cylCoord(k,2),i,j) < cylCoord(k,3)+.3)...
            %                     && (distance(cylCoord(k,1),cylCoord(k,2),i,j) > cylCoord(k,3)-1.3) )
            if distance(cylCoord(k,1),cylCoord(k,2),i,j) < cylCoord(k,3)+.3
                if k <= length(moving)/4
                    MAP(i,j,cylCoord(k,4))=-1;
                    Obst(a,1)=i;
                    Obst(a,2)=j;
                    Obst(a,3)=cylCoord(k,4);
                    a=a+1;
                else
                    if isempty(Obst_i)
                        Obst_i = a-1;
                    end
                    MAP(i,j,1:cylCoord(k,4))=-1;
                    a2=a+cylCoord(k,4)-1;
                    Obst(a:a2,1)=i;
                    Obst(a:a2,2)=j;
                    Obst(a:a2,3)=1:cylCoord(k,4);
                    a=a2+1;
                end
            end
        end
    end
end
if isempty(Obst_i) && isempty(cylCoord) == 0
    Obst_i = length(Obst);
end

if MAP(target(1),target(2),target(3)) == -1
    error('Target is within obstacle');
end
% numObst = length(Obst);
%            if ( (distance(cylCoord(k,1),cylCoord(k,2),i,j) < cylCoord(k,3)+.2) )

% FIND INITIAL PATH %
run A_Star1_3D.m
opsize = size(Optimal_path,1);
for a=1:opsize % Add path to OPM
    Opt_path_master(a,:)=Optimal_path(opsize+1-a,:);
end
recalc_counter = 0;

% PLOT START CONDITIONS %
plot3(0,0,0)
axis([1 MAX_X+1 1 MAX_Y+1 1 MAX_Z+1])
hold on;
grid on;

plot3(start(1),start(2),start(3),'bd'); %% Plot Start
UAM=plot3(start(1),start(2),start(3),'go'); %% Plot UAM
plot3(target(1),target(2),target(3),'gd'); %% Plot Target
% Opt_path_master = [start(1),start(2),start(3)]; %% Initialise path
path = plot3(Opt_path_master(:,1),Opt_path_master(:,2),Opt_path_master(:,3),'k-','LineWidth',1);
% if isempty(moving) == 0 && isempty(fixed) == 0
%         centObst = plot3(cylCoord(1:length(moving)/4,1),cylCoord(1:length(moving)/4,2),cylCoord(1:length(moving)/4,4),'r^'); %% Plot airplanes
%         for k=1:numCyl
%             cylFig(k)=surf(x(:,:,k),y(:,:,k),z(:,:,k),'FaceColor','r','EdgeColor','none','FaceAlpha',0.7);
%         end
% end
if isempty(moving) == 0 || isempty(fixed) == 0
        for k=1:numCyl
            cylFig(k)=surf(x(:,:,k),y(:,:,k),z(:,:,k),'FaceColor','r','EdgeColor','none','FaceAlpha',0.7);
        end
        if isempty(moving) == 0
            centObst = plot3(cylCoord(1:length(moving)/4,1),cylCoord(1:length(moving)/4,2),cylCoord(1:length(moving)/4,4),'r^'); %% Plot airplanes
        end
end

%allObst = plot3(Obst(:,1),Obst(:,2),Obst(:,3),'ro'); % test

% END INITIALISATION %

% % BEGIN LOOP % %
t=1;

while ( (get(UAM,'XData') ~= target(1) || get(UAM,'YData') ~= target(2))...
        || get(UAM,'ZData') ~= target(3) ) % If target not reached
    
% % MOVE OBSTACLES % %
    for a=1:Obst_i
        if ( (1 <= Obst(a,1)+obsDirec(1)) && (Obst(a,1)+obsDirec(1) <= MAX_X) &&...
               (1 <= Obst(a,2)+obsDirec(2)) && (Obst(a,2)+obsDirec(2) <= MAX_Y) )
           MAP(Obst(a,1),Obst(a,2),Obst(a,3)) = 2;
           Obst(a,1)=Obst(a,1)+obsDirec(1);
           Obst(a,2)=Obst(a,2)+obsDirec(2);
        end
    end
    for a=1:Obst_i
        MAP(Obst(a,1),Obst(a,2),Obst(a,3)) = -1;
    end
    
%     for a=1:length(Obst) % Move all obstacles (phase 1)
%         MAP(Obst(a,1),Obst(a,2),Obst(a,3)) = 2;
%     end
%     Obst(:,1) = Obst(:,1)+dir(1);
%     Obst(:,2) = Obst(:,2)+dir(2);
%     for a=1:length(Obst) % Move all obstacles (phase 2)
%         MAP(Obst(a,1),Obst(a,2),Obst(a,3)) = -1;    
%     end
    
% % Check if path needs refreshing (if obst crosses)

for a=t:length(Opt_path_master)
    for b=1:Obst_i
        if ( (Opt_path_master(a,1) == Obst(b,1) && Opt_path_master(a,2) == Obst(b,2))...
                && Opt_path_master(a,3) == Obst(b,3) )
            start(1) = Opt_path_master(t,1);
            start(2) = Opt_path_master(t,2);
            start(3) = Opt_path_master(t,3);
            run A_Star1_3D.m
            opsize = size(Optimal_path,1);
            t=t+1;
            Opt_path_master(t:t+opsize-1,1)=flip(Optimal_path(:,1));
            Opt_path_master(t:t+opsize-1,2)=flip(Optimal_path(:,2));
            Opt_path_master(t:t+opsize-1,3)=flip(Optimal_path(:,3));
            recalc_counter=recalc_counter+1;
        end
    end
end

% % Plot results
pause(.25) 
if isempty(moving) == 0 % If moving cylinders exist
    x(:,:,1:length(moving)/4) = x(:,:,1:length(moving)/4)+obsDirec(1);%% Move obstacles
    y(:,:,1:length(moving)/4) = y(:,:,1:length(moving)/4)+obsDirec(2);
    for k = 1:numCyl
        set(cylFig(k),'XData',x(:,:,k),'YData',y(:,:,k));
    end
    cylCoord(:,1) = cylCoord(:,1)+obsDirec(1);
    cylCoord(:,2) = cylCoord(:,2)+obsDirec(2);
    set(centObst,'XData',cylCoord(1:length(moving)/4,1),'YData',cylCoord(1:length(moving)/4,2))
end
set(path,'XData',Opt_path_master(:,1),'YData',Opt_path_master(:,2),'ZData',Opt_path_master(:,3)) %% Draw path
set(UAM,'XData',Opt_path_master(t,1),'YData',Opt_path_master(t,2),'ZData',Opt_path_master(t,3)) %% Move aircraft
drawnow

t = t+1;

end

disp(['Time = ',num2str(length(Opt_path_master)),' ticks.'])
%toc