%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A* ALGORITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%LISTS USED FOR ALGORITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%OPEN LIST STRUCTURE
%--------------------------------------------------------------------------
%IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
%--------------------------------------------------------------------------
OPEN=[];
%CLOSED LIST STRUCTURE
%--------------
%X val | Y val |
%--------------
% CLOSED=zeros(MAX_VAL,2);
CLOSED=[];

%Put all obstacles on the Closed list
n=1;%Dummy counter
for i=1:MAX_X
    for j=1:MAX_Y
        for k=1:MAX_Z
            if (MAP(i,j,k) == -1)
            CLOSED(n,1)=i; 
            CLOSED(n,2)=j; 
            CLOSED(n,3)=k;
            n=n+1;
            end
        end
    end
end
CLOSED_COUNT=size(CLOSED,1);
numPts=CLOSED_COUNT;
%set the starting node as the first node
xNode=start(1);
yNode=start(2);
zNode=start(3);
OPEN_COUNT=1;
path_cost=0;
goal_distance=distance_3D(xNode,yNode,zNode,target);
OPEN(OPEN_COUNT,:)=insert_open_3D(xNode,yNode,zNode,xNode,yNode,zNode,path_cost,goal_distance,goal_distance);
OPEN(OPEN_COUNT,1)=0;
CLOSED_COUNT=CLOSED_COUNT+1;
CLOSED(CLOSED_COUNT,1)=xNode;
CLOSED(CLOSED_COUNT,2)=yNode;
CLOSED(CLOSED_COUNT,3)=zNode;
NoPath=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START ALGORITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while ( ((xNode ~= target(1) || yNode ~= target(2)) || zNode ~= target(3)) && NoPath == 1 )
 exp_array=expand_array_3D(xNode,yNode,zNode,path_cost,uamDirecX,uamDirecY,uamDirecZ,target,CLOSED,MAX_X,MAX_Y,MAX_Z);
 exp_count=size(exp_array,1);
 %UPDATE LIST OPEN WITH THE SUCCESSOR NODES
 %OPEN LIST FORMAT
 %--------------------------------------------------------------------------
 %IS ON LIST 1/0 |X val |Y val |Z val |Parent X val |Parent Y val |Parent Z val |h(n) |g(n)|f(n)|
 %--------------------------------------------------------------------------
 %EXPANDED ARRAY FORMAT
 %--------------------------------
 %|X val |Y val |Z val |h(n) |g(n)|f(n)|
 %--------------------------------
 for i=1:exp_count
    flag=0;
    for j=1:OPEN_COUNT
        if ( (exp_array(i,1) == OPEN(j,2) && exp_array(i,2) == OPEN(j,3)) && exp_array(i,3) == OPEN(j,4) )
            OPEN(j,10)=min(OPEN(j,10),exp_array(i,6)); %#ok<*SAGROW>
            if OPEN(j,10)== exp_array(i,6)
                %UPDATE PARENTS,gn,hn
                OPEN(j,5)=xNode;
                OPEN(j,6)=yNode;
                OPEN(j,7)=zNode;
                OPEN(j,8)=exp_array(i,4);
                OPEN(j,9)=exp_array(i,5);
                OPEN(j,10)=exp_array(i,6);
            end%End of minimum fn check
            flag=1;
        end%End of node check
%         if flag == 1
%             break;
    end%End of j for
    if flag == 0
        OPEN_COUNT = OPEN_COUNT+1;
        OPEN(OPEN_COUNT,:)=insert_open_3D(exp_array(i,1),exp_array(i,2),exp_array(i,3),xNode,yNode,zNode,exp_array(i,4),exp_array(i,5),exp_array(i,6));
    end%End of insert new element into the OPEN list
 end%End of i for
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %END OF WHILE LOOP
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %Find out the node with the smallest fn 
  index_min_node = min_fn_3D(OPEN,OPEN_COUNT,target);
  if (index_min_node ~= -1)    
   %Set xNode, yNode and zNode to the node with minimum fn
   xNode=OPEN(index_min_node,2);
   yNode=OPEN(index_min_node,3);
   zNode=OPEN(index_min_node,4);
   path_cost=OPEN(index_min_node,8);%Update the cost of reaching the parent node
  %Move the Node to list CLOSED
  CLOSED_COUNT=CLOSED_COUNT+1;
  CLOSED(CLOSED_COUNT,1)=xNode;%Add lowest fn node to closed list and mark as used on open
  CLOSED(CLOSED_COUNT,2)=yNode;
  CLOSED(CLOSED_COUNT,3)=zNode;
  OPEN(index_min_node,1)=0;
  else
      %No path exists to the Target!!
      NoPath=0;%Exits the loop!
  end%End of index_min_node check
end%End of While Loop
%Once algorithm has run The optimal path is generated by starting of at the
%last node(if it is the target node) and then identifying its parent node
%until it reaches the start node.This is the optimal path

i=size(CLOSED,1);
Optimal_path=[];
xval=CLOSED(i,1);
yval=CLOSED(i,2);
zval=CLOSED(i,3);
i=1;
Optimal_path(i,1)=xval;
Optimal_path(i,2)=yval;
Optimal_path(i,3)=zval;
i=i+1;

if ( ((xval == target(1)) && (yval == target(2))) && zval == target(3) )
    inode=0;
   %Traverse OPEN and determine the parent nodes
   parent_x=OPEN(node_index_3D(OPEN,xval,yval,zval),5);%node_index returns the index of the node
   parent_y=OPEN(node_index_3D(OPEN,xval,yval,zval),6);
   parent_z=OPEN(node_index_3D(OPEN,xval,yval,zval),7);
   
   while ( (parent_x ~= start(1) || parent_y ~= start(2)) || parent_z ~= start(3) )
           Optimal_path(i,1) = parent_x;
           Optimal_path(i,2) = parent_y;
           Optimal_path(i,3) = parent_z;
           %Get the grandparents:-)
           inode=node_index_3D(OPEN,parent_x,parent_y,parent_z);
           parent_x=OPEN(inode,5);%node_index returns the index of the node
           parent_y=OPEN(inode,6);
           parent_z=OPEN(inode,7);
           i=i+1;
   end
end