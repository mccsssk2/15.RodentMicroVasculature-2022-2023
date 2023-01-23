%
% This program is interactive.
% SRK. Next step is:
% a) remove blobs
% b) remove artefacts by editing blobs.xlsx
% c) remove dangling vessels.
% d) put in proper edge coordinates.
% e) put in proper bifurcation/confluence coordinates.
% f) make swc.
%
%
clear all
clear all
close all
close all
%
%
% read the blobs data.
blobs = load('blobs.dat');
% read connectivity.
conn = load('connectivity.dat');
%
% read the vessels sequence that I got from the zip file.
fid 		= fopen('vesselsInSequence.dat');
fnames 	= textscan( fid, '%s', 'Delimiter', '\n' );

Nsample = 1;

figure('Renderer', 'painters', 'Position', [30 30 600 1000])

for i=1:1:length(fnames{1})

	str 			= strcat('ROIs/', fnames{1}{i});
	sROI 		= ReadImageJROI(str);
	clear str;
	coodsRaw 	= sROI.mnCoordinates;
	if(blobs(i,1)==(i-1))
	myblob		= blobs(i, 2);
	else
	fprintf("the trimming has an issue, exiting.\n");
	return;
	end;
	
	coods = coodsRaw(myblob:end, :);
	
	plot(coods(:,1), coods(:,2),'LineWidth',4);
	hold on;
	
	% save.
	str = sprintf("noblobcurve%d.dat", i);
	writematrix(coods, str, "Delimiter","\t");

	clearvars -except i fnames blobs conn Nsamples
end;

% now you need gnuplot to be open to get coordinates using mouse. Get one start and one end coordinate, and write in blobs.xlsx.
fprintf("Start your gnuplot, open the blobs excel\n");
for i=1:1:length(fnames{1})

	if(conn(i,2)==i)
	str 			= strcat('ROIs/', fnames{1}{i});
	sROI 		= ReadImageJROI(str);
	clear str;
	coodsRawMe 	= sROI.mnCoordinates; % me curve.

	if(blobs(i,1)==(i-1))
	myblob		= blobs(i, 2);
	else
	fprintf("the trimming has an issue, exiting.\n");
	return;
	end;

	coodsMe 	= sROI.mnCoordinates(myblob:end,:); % me curve.

	clear sROI;
	end;
	
	p1 = -1; p2 = -1;
	if(conn(i,3)>0)
	p1 = conn(i,3);
	str 			= strcat('ROIs/', fnames{1}{p1});
	sROI 		= ReadImageJROI(str);
	clear str;	
	coodsRawP1 	= sROI.mnCoordinates; % parent1.

	if(blobs(p1,1)==(p1-1))
	myblobp1		= blobs(p1, 2);
	else
	fprintf("the trimming has an issue, exiting.\n");
	return;
	end;

	coodsP1 	= sROI.mnCoordinates(myblobp1:end,:); % parent1.

	clear sROI;
	end;

	if(conn(i,4)>0)
	p2 = conn(i,4);
	str 			= strcat('ROIs/', fnames{1}{p2});
	sROI 		= ReadImageJROI(str);
	clear str;	
	coodsRawP2 	= sROI.mnCoordinates; % parent2.

	if(blobs(p2,1)==(p2-1))
	myblobp2		= blobs(p2, 2);
	else
	fprintf("the trimming has an issue, exiting.\n");
	return;
	end;

	coodsP2 	= sROI.mnCoordinates(myblobp2:end,:); % parent2.

	clear sROI;
	end;

	figure('Renderer', 'painters', 'Position', [30 30 600 1000])
	plot(coodsRawMe(:,1), coodsRawMe(:,2),'LineWidth',4, 'color','red');
	hold on;
	if(p1>0)
	plot(coodsRawP1(:,1), coodsRawP1(:,2),'LineWidth',4, 'color','blue');
	hold on;
	end;
	if(p2>0)
	plot(coodsRawP2(:,1), coodsRawP2(:,2),'LineWidth',4, 'color','green');
	hold on;
	end;
	axis([0 1200 0 1920]);
	str = sprintf("me: %d, p1: %d, p2: %d", i, p1, p2);
	text(100,100, str, 'FontSize',24);
	clear str;
	fprintf("junction (me, p1, p2): %d %d %d\n", i, p1, p2);
	pause; % user has to press a key to continue.
	close all;


	figure('Renderer', 'painters', 'Position', [30 30 600 1000])
	plot(coodsMe(:,1), coodsMe(:,2),'LineWidth',4, 'color','red');
	hold on;
	if(p1>0)
	plot(coodsP1(:,1), coodsP1(:,2),'LineWidth',4, 'color','blue');
	hold on;
	end;
	if(p2>0)
	plot(coodsP2(:,1), coodsP2(:,2),'LineWidth',4, 'color','green');
	hold on;
	end;
	axis([0 1200 0 1920]);
	str = sprintf("me: %d, p1: %d, p2: %d", i, p1, p2);
	text(100,100, str, 'FontSize',24);
	clear str;
	fprintf("junction (me, p1, p2): %d %d %d\n", i, p1, p2);
	pause; % user has to press a key to continue.
	close all;


	
	clearvars -except i fnames blobs conn Nsamples
end;

