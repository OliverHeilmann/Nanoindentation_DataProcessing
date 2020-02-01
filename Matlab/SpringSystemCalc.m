%% Created by Oliver Arent Heilmann, 26121093
% Note that for this coursework, no rotational or vertical forces are
% present so all answers will be solved in the 'x' direction only. This
% code is also capable of taking masses and nodal accelerations into
% account.
%% Function for Solving Spring Systems (including Masses)
% See comments for instructions on how to input the forces & displcements.
% If the system does not have any nodal accelerations or masses, only input
% FOUR arguments into the function.

% Instructions for function inputs:
    % Number of elements in F == Number of elements in Q
    % ARG 1: [F]=[Fx1;Fx2, . . . ;Fxn], NaN for UNKNOWN forces
    % ARG 2: [Q]=[qx1;qx2, . . . ;qxn], NaN for UNKNOWN displacements, 0 for fixed points
    % ARG 3: For [k]=[Stiffness1, Stiffness2, . . . ,Stiffness n]
    % ARG 4: Element connectivety, [elem_con]=[node 1 to 2; node 2 to n] 
    % ARG 5: Acceleration values at each node, [ax1;ax2, . . . ;axn]
    % ARG 6: Masses at each node, [M1;M2, . . . ;Mn]
function [Displacements, Forces]=SpringSystemCalc(Q,F,k,elem_con,ddQ,Mass)
    %% Calculable Spring System Properties (including Masses)
    % The questions in this coursework do not have accleration or masses
    % associated with them however this code is able to take them as input
    % arguments. For the purposes of these questions their values are set to
    % zero.
    if nargin==4               % If only 4 arguments are inputted i.e. no {ddQ} or [M]    
        Mass=zeros(length(Q),1); ddQ=Mass;
    elseif nargin~=4 && nargin~=6       % If neither 4 or 6 arguments are inputted
        disp('There must be 4 OR 6 inputs only.')
        disp('    ->If the system does NOT have masses, only use 4 inputs')
        disp('    ->If the system DOES have masses, use 6 inputs')
        Forces=[];Displacements=Forces; % Defining expected function outputs to avoid consol error
        return
    end
    nodes=max(max(elem_con));  % Nodes = highest number found in element connectivety
    KGlobal=zeros(nodes);      % Generate a maxtix large enough for all nodes
    M=diag(Mass);        % Make a matrix with Masses in Diagonal
    %% Assembly of Stiffness Matrix of n Nodes
    % For elements 1:n, a stiffness matrix is formed and then each element is
    % placed in its correct location it the global stiffness matrix). 
    for i=1:length(k)
        ke=k(i)*[1 -1;-1 1];   % General Stiffness Matrix
        part1=elem_con(i,1);   % Part 1 for Each Element
        part2=elem_con(i,2);   % Part 2 for Each Element
        KGlobal(part1,part1)=KGlobal(part1,part1)+ke(1,1);
        KGlobal(part1,part2)=KGlobal(part1,part2)+ke(1,2);
        KGlobal(part2,part1)=KGlobal(part2,part1)+ke(2,1);
        KGlobal(part2,part2)=KGlobal(part2,part2)+ke(2,2);
    end
    %% Creating a Solvable System of Equations
    % In order to determine the unknown nodal displacements we must use the
    % method of deleting A(i:end,i) & A(i,i:end) elements (where i is the row
    % and column where nodal displacements = 0). Note: {F}=[M]{ddQ}+[K]{Q}
    delete_vals=[];
    j=1;
    for i=1:(nodes)
        if Q(i,1)== 0
            delete_vals(j)=i; %#ok<AGROW>
            j=j+1;
        end
    end
    K1=KGlobal(~ismember(1:size(KGlobal, 1),delete_vals),...
               ~ismember(1:size(KGlobal, 1),delete_vals));
    M1=M(~ismember(1:size(KGlobal, 1),delete_vals),...
         ~ismember(1:size(KGlobal, 1),delete_vals));
    Q1=Q(~ismember(1:size(KGlobal, 1),delete_vals), 1);
    F1=F(~ismember(1:size(KGlobal, 1),delete_vals), 1);
    ddQ1=ddQ(~ismember(1:size(KGlobal, 1),delete_vals), 1);
    Fcalc=(M1*ddQ1)+(K1*Q1);
    Qcalc=((K1^-1)*F1)-(M1*ddQ1);
    %% Substituting Calculated Values Back Into General {Q} or {F}
    % Simply substitutes the inputted NaN values with those calculated in
    % the code (for {Q} or {F}).
    j1=1;j2=1;
    for i=1:length(Q)
        if isnan(F(1:end,1))==1
            F(i,1)=Fcalc(j1,1);
            j1=j1+1;
        elseif isnan(Q(i,1))==1
            Q(i,1)=Qcalc(j2,1);
            j2=j2+1;
        end
    end
    Displacements=Q;                % Assigning a value expected function outputs
    Forces=(M*ddQ)+(KGlobal*Q);     % Calculating overall {F} (including reactions)
    %% Check whether this is a Solvable System (based on number of unknowns)
    % This code simply adds up all the NaN values in F1 & Q1; if this
    % number excedes the column length of either {Q1} or {F1} then the system
    % is undefined and the intended solutions cannot be calculated.
    j2=0;
    for i=1:size(F1,1)       % Counting the number of NaNs in F1 & Q1
        if isnan(F1(i,1))==1 && isnan(Q1(i,1))==1
                j2=j2+2;
        elseif isnan(F1(i,1))==1
                j2=j2+1;
        elseif isnan(Q1(i,1))==1
                j2=j2+1;
        end
    end 
    %% Final if Statements to Explain what Operation was Conducted
    % If the system is undefined the code will alert the user. Otherwise,
    % the output will explain what elements have been calculated. Note that
    % I have not added the calculations for a condition where unknowns are
    % present in both {Q} and {F}. . . this could be future work.
    if j2>size(F1,1)==1
        disp('Error: Too Many Unkowns')   
    elseif isnan(Qcalc(1:end,1))==0
        disp('Unknown DISPLACEMENTS have been calculated:')
    elseif isnan(Fcalc(1:end,1))==0
        disp('Unknown FORCES have been calculated:')
    else    
        disp('Consider a condition where some forces AND some displacements are known...')
    end
end
