%% Created by Oliver Arent Heilmann, 26121093
%% Importing 'shear stress depth and maximum values as a function of a/b ratios' Table
table = xlsread('/Users/OliverHeilmann/Documents/Docs/BallBearingCW1.xlsx');
b_dev_a=table(1,1:6);
MaxShearDepth_dev_b=table(2,1:6);
MaxShear_dev_p0=table(3,1:6);
%% Given Values
BallRad=6.35*10^-3;
GrooveRad=6.6*10^-3;
TrackRad=38.9*10^-3;
FRad=700;
z=7;
% Values below as [Steel/Steel,Steel/Diamond,Diamond/Steel,Diamond/Diamond]
setup={'Steel/Steel','Steel/Diamond','Diamond/Steel','Diamond/Diamond'};
YMraceway=[213*10^9,213*10^9,1150*10^9,1150*10^9];
vraceway=[0.29,0.29,0.07,0.07];
YMball=[213*10^9,1150*10^9,213*10^9,1150*10^9];
vball=[0.29,0.07,0.29,0.07];
H=[2.0*10^9,2.0*10^9,2.0*10^9,80*10^9];   % Use lower Hardness value for each condition
%% Calculated Values
% Before running the calculations for differing setups of steel and diamond
% we already know that diamond/diamond is the best. In typical overloading
% conditions, wear can be seen on both the raceway and ball.

% For the Steel/Steel case (case 1) we determine that p0>385 MPa. This
% means the material will transition from elastic deformation to plastic.
for i=1:(numel(YMraceway))
    Rx=((1/BallRad)+(1/-TrackRad))^-1;
    Ry=((1/BallRad)+(1/-GrooveRad))^-1;
    R=((1/Rx)+(1/Ry))^-1;
    P=(5*FRad)/z;
    Ered=(((1-(vraceway(i))^2)/YMraceway(i))+ ... 
        ((1-(vball(i)^2))/YMball(i)))^-1;
    E=1.0003+((0.0596*Rx)/Ry);
    k=1.0339*(Ry/Rx)^0.6360;
    a=((3*(k^2)*E*P*R)/(pi*Ered))^(1/3);
    b=((3*E*P*R)/(pi*k*Ered))^(1/3);
    p0=(3*P)/(2*pi*a*b);
    pm=(2*p0)/3;
    type = sprintf('This Setup is for %s:',setup{i});
    disp(type)
    if pm>(0.4*H(i))    %Contact will yield in a fully plastic manner
        X = sprintf('    Warning! The bearing will plastically deform.');
        disp(X);
        X1 = sprintf('    p0=%s GPa\n    pm=%s GPa\n\nTrying a new setup...\n ',p0,pm);
        disp(X1);
    else                %Applied radial forces area acceptable
        X = sprintf('    Tollerances within limit.\n    p0=%s GPa\n    pm=%s GPa',p0,pm);
        disp(X);
        MaxShear_dev_p0_val=interp1(b_dev_a,MaxShear_dev_p0,b/a);
        MaxShear=MaxShear_dev_p0_val*p0;        %Calculating the Maximum Shear Stress
        MaxShearDepth_dev_b_val=interp1(b_dev_a,MaxShearDepth_dev_b,b/a);
        MaxShearDepth=MaxShearDepth_dev_b_val*b;    %Calculating the Maximum Shear Stress Depth
        X1 = sprintf('    Maximum Shear Force Applied=%s GPa',MaxShear);
        disp(X1);
        X2 = sprintf('    Maximum Shear Force is experienced is at %s mm\n',MaxShearDepth*1000);
        disp(X2)
        break
    end
end
%% Post Calculation Notes
% From these calculations we can see that a maximum shear force of 1.165844e+09 GPa
% is experienced at a depth of 0.07074 mm. In order to stop coating
% delamination one can either provide an adhesive shear strength greater than 
% the maximum shear and/or make sure the bond interface is far away from
% the maximum shear depth. The next thing to decide is whether one would
% want the coating to take the shear force or the bulk material. In our
% case we know that diamond would resist shear forces more readily than
% steel so I would suggest that the coating be made thicker than the 'z'
% value (for instance 3*z). The next thing to consider is whether a safety
% factor should be applied to the system; the magnitude of this would
% depend on how its' use (i.e. aero/astrospace vs automotive). Finally, one
% should consider the manufacturing cost of this ball bearing system.
% Diamond, as well as being extremely hard, is especially difficult to cut
% into rounded shapes (due to the crystalline lattice structure it has).
%% Safety Factor & Diamond Coating Thickness
SafetyFactor=1.5;           % I chose 1.5 however it could be anything
BondStrength=MaxShear*SafetyFactor;
X = sprintf('Adhesive bond strength with safety factor should be %s GPa',BondStrength);
disp(X)
CoatingThickness=MaxShearDepth*1000*3;      % 3*z is suitable here
X1 = sprintf('Coating thickness should be %s mm',CoatingThickness);
disp(X1)