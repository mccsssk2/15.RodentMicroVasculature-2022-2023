%
% SRK. Fit ROI to splines, and organise as ASCII text.
% This program is used to remove the initial blobs and record the starting into connectivity.xlsx.
%
clear all
clear all
close all
close all
%
%
fid 		= fopen('vesselsInSequence.dat');
fnames 	= textscan( fid, '%s', 'Delimiter', '\n' );

Nsample = 1;

for i=1:1:length(fnames{1})
	str = strcat('ROIs/', fnames{1}{i});
	sROI = ReadImageJROI(str);
	coods = sROI.mnCoordinates;
	%
	% now fit it.
	% do the Bezier spline fitting of tAL.
	myCurve = cscvn(coods([1:end],:)');
	[myFittedCurve tt] = fnplt(myCurve);
	myFittedCurve = myFittedCurve';
	%
	%
if(1==1) % make this 1==1 when doing the blob removing.
	figure
	set(gcf, 'Position', [0 300 800 400])
	h1 		= plot(coods(:,1),'black','linewidth',7);
	x_min 	= min(coods(:,1));
	x_max 	= max(coods(:,1));
	y_min 	= min(coods(:,2));
	y_max 	= max(coods(:,2));
%	xt 		= (x_min + x_max)/2;
	xt 		= length(coods(:,1))/2;
	yt 		= (x_min + x_max)/2;
	ylabel('x coordinate.');
	text(xt,yt,num2str(i),'Fontsize',56,'color','black');
	figure
	set(gcf, 'Position', [1000 300 800 400])
	h2 		= plot(coods(:,2),'red','linewidth',6);
	ylabel('y coordinate.');
%	i
	pause(12); % 10 s is too short.
%	input('Press ''Enter'' to continue...','s'); % this may save seconds at each curve - needs user to press enter.
	close all
%	return
end;

if(7==1) % uncomment this when writing the curves.
str = sprintf('curveRaw_%d.dat', i);
writematrix(myFittedCurve,str,'Delimiter','tab');
end;

clearvars -except i Nsample fnames

end

