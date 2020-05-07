clear

%% Zisman Method for surface energy calculation (one component model)

surf_tension = xlsread('sylgard surface energy.xlsx','C8:C10'); %input the values from cells with surface tension values
cos_contact_angle = xlsread('sylgard surface energy.xlsx','H8:H10'); %input the values from cells with contact angle values
x = surf_tension;
y = cos_contact_angle;
p = polyfit(x,y,1); %linear regression
fprintf('The equation of best fit is y = %f * x + %f \n',p(1),p(2))
plot(x,y,'bo');
hold on
plot(x,polyval(p,x),'r-')
yfit = p(1) * x + p(2);
yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1) * var(y);
rsq = 1 - SSresid/SStotal;
fprintf('R-squared value is %f\n',rsq)
surface_energy = (1 - p(2))/p(1); %zisman states that surface energy of surface when contact angle is 0 i.e. cosΘ = 1 
fprintf('Surface Energy by Zisman Method is %f\n', surface_energy)



%% Owens/ Wendt method & Fowkes method for surface energy calculation (two component model)
% Fowkes method is mathematically equivalent to Owens/ Wendt method, but both models has different theoritical basis.
SToverall = xlsread('sylgard surface energy.xlsx','C8:C10');
cos_CA = xlsread('sylgard surface energy.xlsx','H8:H10');
Disp = xlsread('sylgard surface energy.xlsx','D8:D10');
Polar = xlsread('sylgard surface energy.xlsx','E8:E10');
y1 = (SToverall.*(cos_CA + 1))./(2.*((Disp).^0.5))
x1 = ((Polar).^0.5)./((Disp).^0.5)
p1 = polyfit(x1,y1,1);
fprintf('The equation of best fit is y = %f * x + %f \n',p1(1),p1(2))
plot(x1,y1,'bo');
hold on
plot(x1,polyval(p1,x1),'r-')
yfit1 = p1(1) * x1 + p1(2);
yresid1 = y1 - yfit1;
SSresid1 = sum(yresid1.^2);
SStotal1 = (length(y1)-1) * var(y1);
rsq1 = 1 - SSresid1/SStotal1;
fprintf('R-squared value is %f\n',rsq1)
surface_energy_polar = p1(1)^2;
surface_energy_dispersive = p1(2)^2;
fprintf('Polar and Dispersive components of Surface Energy by Owen/Wendt Method are respectively %f and %f \n', surface_energy_polar,surface_energy_dispersive)
fprintf('Thus, the overall surface energy is %f \n',surface_energy_polar + surface_energy_dispersive)



%% Van Oss-Good method for surface energy calculation (three component model)
% Set 4: Paper (neutral grade)
% The primary equation is: σL(1+cosΘ) = 2 [ (σsD σLD )1/2 + (σs+ σL- )1/2 + (σs- σL+ )½ ]
% In order to find the surface energy components, we follow these steps:
% 1] We take a liquid with only dispersive component ( no base/acid component). Here, diiodomethane.
ST_diiodo = 50.8;
cos_CA_diiodo = 0.34202;
disp_diiodo = 50.8;
surface_energy_dispersive_2 = ((ST_diiodo*(cos_CA_diiodo + 1))^2) / (4*(disp_diiodo));
fprintf('Dispersive component of Surface Energy of paper is %f\n', surface_energy_dispersive_2)
s2 = surface_energy_dispersive_2;

%2] We take a liquid with no acid component to find acid component of solid surface energy. Here, tetra-hydro-furan
ST_tetra = 27.4;
cos_CA_tetra = 0.78152;
disp_tetra = 12.4;
base_tetra = 15;
surface_energy_acid =  ((((ST_tetra*(1+cos_CA_tetra))/2) - ((s2*disp_tetra)^0.5))^2)/base_tetra;
fprintf('Acid component of Surface Energy of paper is %f\n', surface_energy_acid)
s3 = surface_energy_acid;

%3] We take liquid with no base component to find base component of solid surface energy. Here, chloroform.
ST_chloro = 27.1; 
cos_CA_chloro = 0.981627;
disp_chloro = 23.3; 
acid_chloro = 3.8;
surface_energy_base = ((((ST_chloro*(1+cos_CA_chloro))/2) - ((s2*disp_chloro)^0.5))^2)/acid_chloro;
fprintf('Base component of Surface Energy of paper is %f\n', surface_energy_base)
fprintf('Overall Surface Energy of paper is %f\n', s2 + s3 + surface_energy_base)



%% Thank You