function dist = distance_3D(x1,y1,z1,target)
%This function calculates the distance between any two cartesian 
%coordinates.
%   Copyright 2009-2010 The MathWorks, Inc.
dist=sqrt((x1-target(1))^2 + (y1-target(2))^2 + (z1-target(3))^2); 
