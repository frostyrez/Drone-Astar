function [obsDirec,uamDirecX,uamDirecY,uamDirecZ] = direction(dirInput,start,target)
% % Obstacle & UAM direction finder function
%

% Find Obstacle Direction
if strcmp(dirInput,'N') == 1
    obsDirec(1)=0;
    obsDirec(2)=1;
elseif strcmp(dirInput,'NE') == 1
    obsDirec(1)=1;
    obsDirec(2)=1;
elseif strcmp(dirInput,'E') == 1
    obsDirec(1)=1;
    obsDirec(2)=0;
elseif strcmp(dirInput,'SE') == 1
    obsDirec(1)=1;
    obsDirec(2)=-1;
elseif strcmp(dirInput,'S') == 1
    obsDirec(1)=0;
    obsDirec(2)=-1;
elseif strcmp(dirInput,'SW') == 1
    obsDirec(1)=-1;
    obsDirec(2)=-1;
elseif strcmp(dirInput,'W') == 1
    obsDirec(1)=-1;
    obsDirec(2)=0;
elseif strcmp(dirInput,'NW') == 1
    obsDirec(1)=-1;
    obsDirec(2)=1;
end

% Find UAM Direction
uamDirecX = [1 0 -1]; % All directions
uamDirecY = [1 0 -1];
uamDirecZ = [1 0 -1];

coordDif(1) = target(1) - start(1); % Find largest coord difference
coordDif(2) = target(2) - start(2);
coordDif(3) = target(3) - start(3);
[~,d] = max(abs(coordDif));

if d == 1 % If largest distance is in x
    if coordDif(1) > 0 % And positive
        uamDirecX = 1; % Then force x-postive movement
    else
        uamDirecX = -1; % Otherwise force x-negative movement
    end
elseif d == 2 % If largest distance is in y
    if coordDif(2) > 0
        uamDirecY = 1;
    else
        uamDirecY = -1;
    end
else
    if coordDif(3) > 0
        uamDirecZ = [0 1];
    else
        uamDirecZ = [0 -1];
    end
end

end