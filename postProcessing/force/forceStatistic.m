%-----------------------reading data module-------------------------------%
clear all;
clc;

pwd

% greater than 10
readingFromWhichLine = 10;

% sampling @ what frequency?
deltT = 10;
[Forcecoefficients, ...
    VarName2, ...
     VarName3, ...
      VarName4, ...
       VarName5, ...
        VarName6] = ...
    textread('forceCoeffs.dat', ...
        '%f %f %f %f %f %f', ...
            'headerlines', ...
                readingFromWhichLine);

% reading velocity; 25/29 is a magical number
fid=fopen('forceCoeffs.dat');
findingVelocity = textscan(fid, '%s');
inletVelocity=str2double(findingVelocity{1}{25});
projectionLength=str2double(findingVelocity{1}{29});

Forcecoefficients_readAtIntval = Forcecoefficients(1: ...
				                   deltT: ...
				                   length ...
				                   (Forcecoefficients),...
				                   1);
VarName3_readAtIntval          = VarName3(1:deltT:length(VarName3),1);
VarName4_readAtIntval          = VarName4(1:deltT:length(VarName4),1);

% alpha is angle of attack
alpha = 0;

% resultant flow velocity

%flowSpeed = inletVelocity*cos(alpha);
flowSpeed = inletVelocity; 
%cl = VarName4_readAtIntval/(cos(alpha))^2;
cl = VarName4_readAtIntval;

% Projection length. This is different from O.F.
% It does not include the axial length.
% a.k.a # lRef
% projectionLength  = 9.000000e-02;

dt                = Forcecoefficients_readAtIntval(2) - ...
                    Forcecoefficients_readAtIntval(1);
displayTimeStart  = Forcecoefficients_readAtIntval(1);
displayTimeEnd    = Forcecoefficients_readAtIntval( ...
		    length(Forcecoefficients_readAtIntval));

%-------------------------processing lift coefficient---------------------%
% using FFT to find the maximum frquency of a given data
time = Forcecoefficients_readAtIntval;
relNums = cl;
Y = fft(relNums);
Y(1) = [];
n = length(Y);
power = abs(Y(1:floor(n/2))).^2;
nyquist = 1/2;
freq = (1:n/2)/(n/2)*nyquist/dt;
index = find(power == max(power));
mainPeriodStr = num2str(freq(index));

% Strouhal number
St = freq(index)*projectionLength/flowSpeed;
Amp = max(cl);
%----------------------processing lift coefficient end--------------------%

%-----------------------processing drag coefficient-----------------------%
dragCoefficient = VarName3_readAtIntval;
FlowTime = Forcecoefficients_readAtIntval;
%---------------------processing drag coefficient end---------------------%

formatSpec = ['\nCl r.m.s is %3.2f;'...
              '\nFlowSpeed is %2.2f;'...
	      '\nAngle of attack is %2.0f degree;'...
	      '\nStrouhal number is %5.2f;'...
	      '\nNormalized St is %2.2f;'...
	      '\nMean Cd is %2.2f;'...
	      '\nNormalized Mean Cd is %2.2f;'];

fprintf(formatSpec,...
        rms(cl), ...
	flowSpeed, ...
	alpha, ...
        St, ...	
	St./cosd(alpha),...
        mean(dragCoefficient), ...
        mean(dragCoefficient)./(cosd(alpha)).^2);
