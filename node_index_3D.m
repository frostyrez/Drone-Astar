function n_index = node_index_3D(OPEN,xval,yval,zval)
    %This function returns the index of the location of a node in the list
    %OPEN
    %
    
    i=1;
    while ( (OPEN(i,2) ~= xval || OPEN(i,3) ~= yval) || OPEN(i,4) ~= zval)
        i=i+1;
    end
    n_index=i;
end